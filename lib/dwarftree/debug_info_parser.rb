require 'dwarftree/debug_ranges_parser'
require 'dwarftree/die'
require 'strscan'

class Dwarftree::DebugInfoParser
  CommandError = Class.new(StandardError)
  ParserError = Class.new(StandardError)

  using Module.new {
    refine StringScanner do
      def scan!(pattern)
        scan(pattern).tap do |result|
          if result.nil?
            raise ParserError.new("Expected #{pattern.inspect} but got: #{rest}")
          end
        end
      end
    end
  }

  def self.parse(object)
    begin
      offset_ranges = Dwarftree::DebugRangesParser.parse(object)
    rescue Dwarftree::DebugRangesParser::CommandError => e
      raise CommandError.new(e.message)
    end

    cmd = ['objdump', '--dwarf=info', object]
    debug_info = IO.popen(cmd, &:read)
    unless $?.success?
      raise CommandError.new("Failed to run: #{cmd.join(' ')}")
    end
    new(offset_ranges).parse(debug_info)
  end

  def initialize(offset_ranges)
    @offset_die = {} # { 12345 => #<Dwarftree::DIE:* ...> }
    @offset_ranges = offset_ranges # { 12345 => [(12345..67890), ...] }
  end

  # @param [String] debug_info
  # @return [Array<Dwarftree::DIE::CompileUnit>]
  def parse(debug_info)
    compile_units = []
    each_compilation_unit(debug_info) do |compilation_unit|
      compile_units << parse_compilation_unit(compilation_unit)
    end
    compile_units
  end

  private

  # @param [String] debug_info
  def each_compilation_unit(debug_info)
    compilation_units = debug_info.split(/^  Compilation Unit @ offset 0x\h+:\n/)
    compilation_units.drop(1).each do |compilation_unit|
      dies = compilation_unit.sub!(/\A(   [^:]+: [^\n]+\n)+/, '')
      if dies.nil?
        raise ParserError.new("Expected Compilation Unit to have attributes but got: #{dies}")
      end
      yield(dies)
    end
  end

  # @param [String] compilation_unit
  def parse_compilation_unit(compilation_unit)
    dies = []
    each_die(compilation_unit) do |die|
      if parsed = parse_die(die)
        dies << parsed
      end
    end
    dies.each do |die|
      resolve_references(die)
      die.freeze
    end
    build_tree(dies)
  end

  # @param [String] dies
  def each_die(dies, &block)
    dies.scan(/^ <\d+><\h+>:[^\n]+\n(?:    <\h+> [^\n]+\n)*/, &block)
  end

  # @param [String] die
  def parse_die(die)
    scanner = StringScanner.new(die)

    scanner.scan!(/ <(?<level>\d+)><(?<offset>\h+)>: Abbrev Number: (\d+ \(DW_TAG_(?<type>[^\)]+)\)|0)\n/)
    level, offset, type = scanner[:level], scanner[:offset], scanner[:type]
    return nil if type.nil?

    attributes = {}
    while scanner.scan(/    <\h+>   DW_AT_(?<key>[^ ]+) *:( \([^\)]+\):)? (?<value>[^\n]+)\n/)
      key, value = scanner[:key], scanner[:value]
      attributes[key.to_sym] = value
    end

    build_die(type, level: Integer(level), offset: offset.to_i(16), attributes: attributes)
  end

  # @param [String] type
  # @param [Integer] level
  # @param [Integer] offset
  # @param [Hash{ Symbol => String }] attributes
  # @return [Dwarftree::DIE::*]
  def build_die(type, level:, offset:, attributes:)
    const = type.split('_').map { |s| s.sub(/\A\w/, &:upcase) }.join
    klass = Dwarftree::DIE.const_get(const, false)
    begin
      die = klass.new(**attributes)
    rescue ArgumentError
      $stderr.puts "Caught ArgumentError on Dwarftree::DIE::#{const}.new"
      raise
    end
    die.type  = type
    die.level = level
    @offset_die[offset] = die
  end

  def resolve_references(die)
    if die.respond_to?(:ranges) && die[:ranges]
      die.ranges = @offset_ranges.fetch(die[:ranges].to_i(16))
    end
    if die.respond_to?(:abstract_origin) && die[:abstract_origin]
      offset = die[:abstract_origin].match(/\A<0x(?<offset>\h+)>\z/)[:offset]
      die.abstract_origin = @offset_die.fetch(offset.to_i(16))
    end
  end

  # @param [Array<Dwarftree::DIE::*>] nodes
  def build_tree(nodes)
    stack = [nodes.first]
    nodes.drop(1).each do |node|
      while stack.last.level + 1 > node.level
        stack.pop
      end
      if stack.last.level + 1 != node.level
        raise ParserError.new("unexpected node level #{node.level} against stack #{stack.last.level}")
      end
      stack.last.children << node
      stack.push(node)
    end
    stack.first
  end
end

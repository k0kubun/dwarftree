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
    cmd = ['objdump', '--dwarf=info', object]
    debug_info = IO.popen(cmd, &:read)
    unless $?.success?
      raise CommandError.new("Failed to run: #{cmd.join(' ')}")
    end
    new.parse(debug_info)
  end

  def initialize
    @die_index = {} # { 12345 => #<Dwarftree::DIE:* ...> }
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
    build_tree(dies)
  end

  # @param [String] dies
  def each_die(dies, &block)
    dies.scan(/^ <\d+><\h+>:[^\n]+\n(?:    <\h+> [^\n]+\n)*/, &block)
  end

  # @param [String] die
  def parse_die(die)
    scanner = StringScanner.new(die)

    scanner.scan!(/ <(?<level>\d+)><(?<index>\h+)>: Abbrev Number: (\d+ \(DW_TAG_(?<type>[^\)]+)\)|0)\n/)
    level, index, type = scanner[:level], scanner[:index], scanner[:type]
    return nil if type.nil?

    attributes = {}
    while scanner.scan(/    <\h+>   DW_AT_(?<key>[^ ]+) *:( \([^\)]+\):)? (?<value>[^\n]+)\n/)
      key, value = scanner[:key], scanner[:value]
      attributes[key.to_sym] = value
    end

    build_die(type, level: Integer(level), index: index.to_i(16), attributes: attributes)
  end

  # @param [String] type
  # @param [Integer] level
  # @param [Integer] index
  # @param [Hash{ Symbol => String }] attributes
  # @return [Dwarftree::DIE::*]
  def build_die(type, level:, index:, attributes:)
    const = type.split('_').map { |s| s.sub(/\A\w/, &:upcase) }.join
    klass = Dwarftree::DIE.const_get(const, false)
    begin
      @die_index[index] = klass.new(**attributes) do |die|
        die.type  = type
        die.level = level
        if die.respond_to?(:die_index=)
          die.die_index = @die_index
        end
      end
    rescue ArgumentError
      $stderr.puts "Caught ArgumentError on Dwarftree::DIE::#{const}.new"
      raise
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

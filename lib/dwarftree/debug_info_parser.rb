require 'dwarftree/die'
require 'strscan'

class Dwarftree::DebugInfoParser
  CommandError = Class.new(StandardError)
  ParserError = Class.new(StandardError)

  def self.parse(object)
    cmd = ['objdump', '--dwarf=info', object]
    debug_info = IO.popen(cmd, &:read)
    unless $?.success?
      raise CommandError.new("Failed to run: #{cmd.join(' ')}")
    end
    new.parse(debug_info)
  end

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

  def initialize
    @stack = []
  end

  # @param [String] debug_info
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

    scanner.scan!(/ <(?<level>\d+)><\h+>: Abbrev Number: (\d+ \(DW_TAG_(?<type>[^\)]+)\)|0)\n/)
    level, type = scanner[:level], scanner[:type]
    return nil if type.nil?

    attributes = {}
    while scanner.scan(/    <\h+>   DW_AT_(?<key>[^ ]+) +:( \([^\)]+\):)? (?<value>[^\n]+)\n/)
      key, value = scanner[:key], scanner[:value]
      attributes[key.to_sym] = value
    end

    build_die(type, level: Integer(level), attributes: attributes)
  end

  # @param [String] type
  # @param [Integer] level
  # @param [Hash{ Symbol => String }] attributes
  def build_die(type, level:, attributes:)
    const = type.split('_').map { |s| s.sub(/\A\w/, &:upcase) }.join
    Dwarftree::DIE.const_get(const, false).new(**attributes)
  rescue => e
    puts type
    raise
  end

  def build_tree(nodes)
  end
end

require 'dwarftree/die'

class Dwarftree::DebugInfoParser
  ParserError = Class.new(StandardError)

  def self.parse(object)
    cmd = ['objdump', '--dwarf=info', object]
    debug_info = IO.popen(cmd, &:read)
    unless $?.success?
      raise ParserError.new("Failed to run: #{cmd.join(' ')}")
    end
    new.parse(debug_info)
  end

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
      dies << parse_die(die)
    end
    construct_tree(dies)
  end

  # @param [String] dies
  def each_die(dies, &block)
    dies.scan(/^ <\h+><\h+>:[^\n]+\n(?:    <\h+> [^\n]+\n)*/, &block)
  end

  # @param [String] die
  def parse_die(die)
    # TODO: implement
  end

  def construct_tree(dies)
  end
end

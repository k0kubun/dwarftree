module Dwarftree
  require 'dwarftree/debug_info_parser'
  require 'dwarftree/tree_filter'
  require 'dwarftree/tree_visualizer'

  # @param [String] object
  # @param [Array<String>] dies
  # @param [Array<String>] subprograms
  # @param [TrueClass,FalseClass] code_size
  def self.run(object, dies:, subprograms:, code_size:)
    begin
      nodes = DebugInfoParser.parse(object)
    rescue DebugInfoParser::CommandError => e
      abort "ERROR: #{e.message}"
    end
    if nodes.empty?
      abort "Debug info was not found in #{object.dump}"
    end

    Dwarftree::TreeFilter.new(dies: dies, subprograms: subprograms).filter!(nodes)
    nodes.each do |node|
      Dwarftree::TreeVisualizer.new(code_size: code_size).visualize(node)
    end
  end
end

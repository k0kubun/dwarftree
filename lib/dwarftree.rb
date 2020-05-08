module Dwarftree
  require 'dwarftree/debug_info_parser'
  require 'dwarftree/tree_filter'
  require 'dwarftree/tree_visualizer'

  # @param [String] object
  # @param [Array<String>] dies
  # @param [Array<String>] subprograms
  def self.run(object, dies:, subprograms:)
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
      Dwarftree::TreeVisualizer.visualize(node)
    end
  end
end

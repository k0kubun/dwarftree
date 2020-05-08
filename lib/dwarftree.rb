module Dwarftree
  require 'dwarftree/debug_info_parser'
  require 'dwarftree/tree_filter'
  require 'dwarftree/tree_visualizer'

  # @param [String] object
  # @param [Array<String>] dies
  # @param [Array<String>] subroutines
  def self.run(object, dies:, subroutines:)
    begin
      nodes = DebugInfoParser.parse(object)
    rescue DebugInfoParser::CommandError => e
      abort "ERROR: #{e.message}"
    end
    if nodes.empty?
      abort "Debug info was not found in #{object.dump}"
    end

    Dwarftree::TreeFilter.filter!(nodes, dies: dies, subroutines: subroutines)
    nodes.each do |node|
      Dwarftree::TreeVisualizer.visualize(node)
    end
  end
end

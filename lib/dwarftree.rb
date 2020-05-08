module Dwarftree
  require 'dwarftree/debug_info_parser'
  require 'dwarftree/tree_filter'
  require 'dwarftree/tree_visualizer'

  # @param [String] object
  # @param [Array<String>] dies
  # @param [Array<String>] symbols
  def self.run(object, dies:, symbols:)
    begin
      nodes = DebugInfoParser.parse(object)
    rescue DebugInfoParser::CommandError => e
      abort "ERROR: #{e.message}"
    end
    if nodes.empty?
      abort "debug_info was not found in #{object.dump}. Compile it with debug flags enabled."
    end

    Dwarftree::TreeFilter.filter!(nodes, dies: dies, symbols: symbols)
    nodes.each do |node|
      Dwarftree::TreeVisualizer.visualize(node)
    end
  end
end

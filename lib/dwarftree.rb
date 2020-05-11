module Dwarftree
  require 'dwarftree/debug_info_parser'
  require 'dwarftree/tree_filter'
  require 'dwarftree/tree_visualizer'

  # @param [String] object
  # @param [Array<String>] dies
  # @param [Array<String>] subprograms
  # @param [TrueClass,FalseClass] show_size
  # @param [TrueClass,FalseClass] sort_size
  def self.run(object, dies:, subprograms:, show_size:, sort_size:)
    begin
      nodes = DebugInfoParser.parse(object)
    rescue DebugInfoParser::CommandError => e
      abort "ERROR: #{e.message}"
    end
    if nodes.empty?
      abort "Debug info was not found in #{object.dump}"
    end

    Dwarftree::TreeFilter.new(dies: dies, subprograms: subprograms).filter!(nodes)
    Dwarftree::TreeVisualizer.new(show_size: show_size, sort_size: sort_size).visualize(nodes)
  end
end

# frozen_string_literal: true
class Dwarftree::TreeFilter
  using Module.new {
    refine Array do
      def flat_map!(&block)
        replace(flat_map(&block))
      end
    end
  }

  # @param [Set<String>] subprograms
  # @param [Set<String>] dies
  def initialize(subprograms:, dies:)
    @subprograms = subprograms
    @dies = dies
  end

  # @param [Array<Dwarftree::DIE::*>] nodes
  def filter!(nodes, filter_subprogram: @subprograms.empty?)
    unless @subprograms.empty?
      filter_subprograms!(nodes)
    end
    unless @dies.empty?
      filter_dies!(nodes)
    end
  end

  private

  # @param [Array<Dwarftree::DIE::*>] nodes - Modified to Array<Dwarftree::DIE::Subprogram> after this call
  def filter_subprograms!(nodes)
    nodes.flat_map! do |node|
      if matching_subprogram?(node)
        node
      else
        filter_subprograms!(node.children)
        node.children
      end
    end
  end

  def filter_dies!(nodes)
    nodes.flat_map! do |node|
      filter_dies!(node.children)

      # Exactly-matched subprogram should not be filtered out
      if matching_subprogram?(node) || @dies.include?(node.type)
        node
      else
        node.children
      end
    end
  end

  def matching_subprogram?(node)
    node.type == 'subprogram' && @subprograms.include?(node.name)
  end
end

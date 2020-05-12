class << Dwarftree::TreeMerger = Object.new
  # @param [Array<Dwarftree::DIE::*>] nodes
  def merge!(nodes)
    merged = []
    nodes.group_by(&:attributes).each do |attrs, same_nodes|
      first_node = same_nodes.first
      same_nodes.drop(1).each do |node|
        first_node.children.push(*node.children)
        first_node.merged << node
      end
      merged << first_node
    end
    nodes.replace(merged)

    nodes.each do |node|
      merge!(node.children)
    end
  end
end

class << Dwarftree::TreeVisualizer = Object.new
  # @param [Dwarftree::DIE::*] node
  def visualize(node, depth: 0)
    puts "#{'  ' * depth}#{node.type} #{node_attributes(node)}"
    node.children.each do |child|
      visualize(child, depth: depth + 1)
    end
  end

  private

  def node_attributes(node)
    attrs = node.class.attributes.map do |attr|
      if value = node.public_send(attr)
        "#{attr}: #{value}"
      end
    end.compact
    return '' if attrs.empty?

    "(#{attrs.join(', ')})"
  end
end

class Dwarftree::TreeVisualizer
  KiB = 1024
  MiB = KiB * 1024

  # @param [TrueClass,FalseClass] show_size
  # @param [TrueClass,FalseClass] sort_size
  def initialize(show_size:, sort_size:)
    @show_size = show_size
    @sort_size = sort_size
  end

  # @param [Array<Dwarftree::DIE::*>] nodes
  def visualize(nodes)
    sort(nodes).each do |node|
      visualize_node(node)
    end
  end

  private

  # @param [Dwarftree::DIE::*] node
  def visualize_node(node, depth: 0)
    size = node_code_size(node)
    print "#{'  ' * depth}#{node.type}"
    puts "#{(" size=#{human_size(size)}" if @show_size && size > 0)} #{node_attributes(node)}"

    sort(node.children).each do |child|
      visualize_node(child, depth: depth + 1)
    end
  end

  def node_attributes(node)
    attrs = node.attributes.map do |attr, value|
      "#{attr}: #{value}"
    end
    return '' if attrs.empty?
    "(#{attrs.join(', ')})"
  end

  def node_code_size(node)
    size = node.merged.map { |n| node_code_size(n) }.compact.sum
    if node.respond_to?(:ranges) && node.ranges
      size += node.ranges.map { |range| range.end - range.begin }.sum
    elsif node.respond_to?(:high_pc) && node.high_pc
      size += node.high_pc.to_i(16) # surprisingly low_pc is not needed to know code size
    end
    size
  end

  def human_size(size)
    if size > MiB
      "%.1fM" % (size.to_f / MiB)
    elsif size > KiB
      "%.1fK" % (size.to_f / KiB)
    else
      size
    end
  end

  def sort(nodes)
    if @sort_size
      nodes.sort_by { |node| -(node_code_size(node) || 0) }
    else
      nodes
    end
  end
end

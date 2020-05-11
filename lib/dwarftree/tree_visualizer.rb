class Dwarftree::TreeVisualizer
  KiB = 1024
  MiB = KiB * 1024

  # @param [TrueClass,FalseClass] code_size
  def initialize(code_size)
    @code_size = code_size
  end

  # @param [Dwarftree::DIE::*] node
  def visualize(node, depth: 0)
    size = node_code_size(node)
    attrs = node_attributes(node)
    puts "#{'  ' * depth}#{node.type}#{(" size=#{human_size(size)}" if size)} #{attrs}"

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
    end
    attrs.compact!

    return '' if attrs.empty?
    "(#{attrs.join(', ')})"
  end

  def node_code_size(node)
    if node.respond_to?(:ranges) && node.ranges
      node.ranges.map { |range| range.end - range.begin }.sum
    elsif node.respond_to?(:high_pc) && node.high_pc
      node.high_pc.to_i(16) # surprisingly low_pc is not needed to know code size
    end
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
end

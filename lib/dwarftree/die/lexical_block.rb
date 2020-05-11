Dwarftree::DIE::LexicalBlock = Dwarftree::DIE.new(
  :low_pc,
  :high_pc,
  :ranges,
  :sibling,
  :abstract_origin,
) do
  def abstract_origin
    self[:abstract_origin]&.type
  end
end

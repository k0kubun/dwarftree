Dwarftree::DIE::InlinedSubroutine = Dwarftree::DIE.new(
  :abstract_origin,
  :entry_pc,
  :ranges,
  :call_file,
  :call_line,
  :sibling,
  :low_pc,
  :high_pc,
) do
  self.attributes = members - [:sibling]

  def abstract_origin
    self[:abstract_origin].name
  end
end

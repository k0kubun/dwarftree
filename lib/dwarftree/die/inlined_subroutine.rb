Dwarftree::DIE::InlinedSubroutine = Dwarftree::DIE.new(
  :abstract_origin,
  :entry_pc,
  :ranges,
  :call_file,
  :call_line,
  :call_column,
  :sibling,
  :low_pc,
  :high_pc,
  :GNU_entry_view,
) do
  self.attributes = [:abstract_origin]

  def abstract_origin
    self[:abstract_origin].name
  end
end

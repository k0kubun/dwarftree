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

  attr_writer :die_index

  def abstract_origin
    index = self[:abstract_origin].match(/\A<0x(?<index>\h+)>\z/)[:index].to_i(16)
    @die_index[index].name
  end
end

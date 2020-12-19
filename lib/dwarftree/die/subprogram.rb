Dwarftree::DIE::Subprogram = Dwarftree::DIE.new(
  :external,
  :name,
  :decl_file,
  :decl_line,
  :decl_column,
  :prototyped,
  :type,
  :low_pc,
  :high_pc,
  :ranges,
  :frame_base,
  :declaration,
  :inline,
  :sibling,
  :artificial,
  :noreturn,
  :GNU_all_call_sites,
  :linkage_name,
  :abstract_origin,
  :GNU_all_tail_call_sites,
) do
  self.attributes = [:name, :abstract_origin, :inline]

  def abstract_origin
    self[:abstract_origin]&.name
  end
end

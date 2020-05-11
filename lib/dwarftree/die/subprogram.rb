Dwarftree::DIE::Subprogram = Dwarftree::DIE.new(
  :external,
  :name,
  :decl_file,
  :decl_line,
  :prototyped,
  :type,
  :low_pc,
  :high_pc,
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
  self.attributes = [:name, :inline]
end

Dwarftree::DIE::Label = Dwarftree::DIE.new(
  :name,
  :decl_file,
  :decl_line,
  :low_pc,
  :abstract_origin,
) do
  def abstract_origin
    self[:abstract_origin]&.name
  end
end

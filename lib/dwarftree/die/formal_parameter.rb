Dwarftree::DIE::FormalParameter = Dwarftree::DIE.new(
  :name,
  :decl_file,
  :decl_line,
  :type,
  :location,
  :abstract_origin,
  :const_value,
) do
  def abstract_origin
    self[:abstract_origin]&.name
  end
end

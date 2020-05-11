Dwarftree::DIE::Variable = Dwarftree::DIE.new(
  :name,
  :decl_file,
  :decl_line,
  :type,
  :external,
  :declaration,
  :location,
  :const_value,
  :artificial,
  :abstract_origin,
  :specification,
) do
  def abstract_origin
    self[:abstract_origin]&.name
  end
end

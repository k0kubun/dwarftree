Dwarftree::DIE::FormalParameter = Dwarftree::DIE.new(
  :name,
  :decl_file,
  :decl_line,
  :decl_column,
  :type,
  :location,
  :abstract_origin,
  :const_value,
  :GNU_locviews,
) do
  def abstract_origin
    self[:abstract_origin]&.name
  end
end

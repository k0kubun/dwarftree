Dwarftree::DIE::CompileUnit = Dwarftree::DIE.new(
  :producer,
  :language,
  :name,
  :comp_dir,
  :ranges,
  :low_pc,
  :high_pc,
  :stmt_list,
  :GNU_macros,
) do
  self.attributes = [:name]

  def name
    File.expand_path(self[:name], comp_dir)
  end
end

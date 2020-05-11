Dwarftree::DIE::GNUCallSite = Dwarftree::DIE.new(
  :low_pc,
  :ranges,
  :sibling,
  :abstract_origin,
  :GNU_tail_call,
  :GNU_call_site_target,
) do
  def abstract_origin
    self[:abstract_origin]&.name
  end
end

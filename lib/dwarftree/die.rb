# Debugging Information Entry
module Dwarftree::DIE
  def self.new(*args, &block)
    Struct.new(:level, :children, *args, keyword_init: true, &block)
  end

  require 'dwarftree/die/array_type'
  require 'dwarftree/die/base_type'
  require 'dwarftree/die/compile_unit'
  require 'dwarftree/die/const_type'
  require 'dwarftree/die/dwarf_procedure'
  require 'dwarftree/die/enumeration_type'
  require 'dwarftree/die/enumerator'
  require 'dwarftree/die/formal_parameter'
  require 'dwarftree/die/gnu_call_site'
  require 'dwarftree/die/gnu_call_site_parameter'
  require 'dwarftree/die/inlined_subroutine'
  require 'dwarftree/die/label'
  require 'dwarftree/die/lexical_block'
  require 'dwarftree/die/member'
  require 'dwarftree/die/pointer_type'
  require 'dwarftree/die/restrict_type'
  require 'dwarftree/die/structure_type'
  require 'dwarftree/die/subprogram'
  require 'dwarftree/die/subrange_type'
  require 'dwarftree/die/subroutine_type'
  require 'dwarftree/die/typedef'
  require 'dwarftree/die/union_type'
  require 'dwarftree/die/unspecified_parameters'
  require 'dwarftree/die/variable'
  require 'dwarftree/die/volatile_type'
end

# Debugging Information Entry
module Dwarftree::DIE
  def self.new(*args, &block)
    Struct.new(:children, *args, keyword_init: true) do
      # Not in members to be ignored in inspect, etc.
      attr_accessor :level

      def initialize(**)
        super
        self.children ||= []
      end

      if block
        instance_exec(&block)
      end
    end
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

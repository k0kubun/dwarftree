# Debugging Information Entry
module Dwarftree::DIE
  using Module.new {
    refine Struct.singleton_class do
      def new(*args, **_opts, &block)
        if args.empty?
          # Pseudo Struct for no-member DIE
          Class.new do
            def self.members
              []
            end

            if block
              class_exec(&block)
            end
          end
        else
          super
        end
      end
    end
  }

  def self.new(*args, &block)
    Struct.new(*args, keyword_init: true) do
      class << self
        attr_accessor :attributes
      end
      self.attributes = members

      # Not in members to avoid a conflict with DIE attributes
      attr_accessor :type, :level, :children, :merged

      def initialize(**kwargs)
        begin
        super
        rescue => e
          binding.irb
        end
        self.children = []
        self.merged = []
      end

      def attributes
        attrs = {}
        self.class.attributes.each do |attr|
          if value = send(attr)
            attrs[attr] = value
          end
        end
        attrs
      end

      if block
        class_exec(&block)
      end
      freeze
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

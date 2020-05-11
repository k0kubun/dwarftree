# Dwarftree

A wrapper of `objdump --dwarf=info` to visualize an object's structure and show code size

## Installation

Prepare Ruby 2.6+, and

```bash
$ gem install dwarftree
```

## Usage
First, make sure your object file has debug symbols (dwarf) and you have `objdump`.

### Dump all entries

```bash
$ dwarftree /tmp/_ruby_mjit_p30080u145.so
compile_unit (name: /tmp/_ruby_mjit_p16698u145.c)
  base_type (byte_size: 8, encoding: 4  (float), name: double)
  base_type (byte_size: 8, encoding: 5  (signed), name: long int)
  ...
  subprogram (name: _mjit102_sinatra_base_rb_force_encoding)
    ...
    lexical_block (ranges: [223864..223982, 224056..224327, 224597..224624, 224704..224720, 224768..224784, 224840..224848, 224880..224896, 224928..225059], sibling: <0x6d3a>)
      variable (name: cc, decl_file: 99, decl_line: 26, type: variable, const_value: 0x55d561e7f3b0)
      variable (name: cc_cme, decl_file: 99, decl_line: 27, type: variable, const_value: 0x55d561ac71a0)
      lexical_block (ranges: [224103..224116, 224132..224317, 224597..224624, 224840..224848, 224928..224952, 224976..225059], sibling: <0x6c86>)
        variable (name: val, decl_file: 99, decl_line: 37, type: variable, location: 0x6fb8 (location list))
        variable (name: calling, decl_file: 99, decl_line: 38, type: variable, location: 0x7014 (location list))
        inlined_subroutine (abstract_origin: vm_call_iseq_setup_normal)
          formal_parameter (type: formal_parameter, location: 0x718a (location list), abstract_origin: local_size)
          formal_parameter (type: formal_parameter, location: 0x718a (location list), abstract_origin: param_size)
  ...
```

### Dump a single subprogram

```bash
$ dwarftree /tmp/_ruby_mjit_p16698u145.so -S _mjit102_sinatra_base_rb_force_encoding
subprogram (name: _mjit102_sinatra_base_rb_force_encoding)
  formal_parameter (name: ec, decl_file: 99, decl_line: 8, type: formal_parameter, location: 0x6c82 (location list))
  formal_parameter (name: reg_cfp, decl_file: 99, decl_line: 8, type: formal_parameter, location: 0x6d8c (location list))
  variable (name: stack, decl_file: 99, decl_line: 10, type: variable, location: 0x6e13 (location list))
  variable (name: original_iseq, decl_file: 99, decl_line: 11, type: variable, const_value: 0x55d5616ff108)
  variable (name: original_body_iseq, decl_file: 99, decl_line: 12, type: variable, const_value: 0x55d5619a74f0)
  label (name: label_0, decl_file: 99, decl_line: 14, low_pc: 0x36a60)
  label (name: label_1, decl_file: 99, decl_line: 24, low_pc: 0x36a78)
  label (name: send_cancel, decl_file: 99, decl_line: 132, low_pc: 0x36aee)
  label (name: cancel, decl_file: 99, decl_line: 150, low_pc: 0x36b17)
  ...
  label (name: ivar_cancel, decl_file: 99, decl_line: 138)
  label (name: exivar_cancel, decl_file: 99, decl_line: 144)
  lexical_block (low_pc: 0x36a74, high_pc: 0x4, sibling: <0x69e7>)
    variable (name: stack_size, decl_file: 99, decl_line: 16, type: variable, const_value: 0)
    variable (name: val, decl_file: 99, decl_line: 17, type: variable, location: 0x6f23 (location list))
  ...
```

### Sort subprograms by code size

```bash
$ dwarftree /tmp/_ruby_mjit_p16698u145.so --show-size --sort-size --die subprogram
subprogram size=12.0K (name: _mjit95_sinatra_base_rb_process_route)
subprogram size=6.4K (name: _mjit133_logger_rb_level_)
subprogram size=6.3K (name: _mjit85_rack_request_rb_POST)
subprogram size=4.9K (name: setup_parameters_complex)
subprogram size=3.9K (name: _mjit43_rack_method_override_rb_call)
subprogram size=3.6K (name: _mjit63_rack_protection_path_traversal_rb_cleanup)
subprogram size=3.6K (name: _mjit64_rack_protection_xss_header_rb_call)
subprogram size=3.5K (name: _mjit14_sinatra_base_rb_body)
subprogram size=3.2K (name: _mjit81_rack_query_parser_rb_parse_nested_query)
subprogram size=3.1K (name: _mjit56_logger_log_device_rb_set_dev)
subprogram size=3.1K (name: _mjit78_rack_request_rb_GET)
subprogram size=3.0K (name: _mjit51_logger_rb_initialize)
subprogram size=3.0K (name: _mjit143_sinatra_base_rb_invoke)
...
```

### Inspect code size of inlined subroutines

```bash
$ dwarftree /tmp/_ruby_mjit_p16698u145.so -S _mjit102_sinatra_base_rb_force_encoding --show-size --sort-size --die inlined_subroutine
subprogram size=1.2K (name: _mjit102_sinatra_base_rb_force_encoding)
  inlined_subroutine size=536 (abstract_origin: vm_sendish)
    inlined_subroutine size=34 (abstract_origin: mjit_exec)
    inlined_subroutine size=14 (abstract_origin: vm_ci_argc)
      inlined_subroutine size=8 (abstract_origin: vm_ci_packed_p)
    inlined_subroutine size=6 (abstract_origin: vm_ci_flag)
    inlined_subroutine size=4 (abstract_origin: VM_ENV_FLAGS_SET)
    inlined_subroutine size=4 (abstract_origin: VM_ENV_FLAGS_SET)
  inlined_subroutine size=342 (abstract_origin: mjit_exec)
    inlined_subroutine size=29 (abstract_origin: mjit_target_iseq_p)
  inlined_subroutine size=264 (abstract_origin: vm_call_iseq_setup_normal)
    inlined_subroutine size=206 (abstract_origin: vm_push_frame)
  inlined_subroutine size=173 (abstract_origin: rb_class_of)
    inlined_subroutine size=15 (abstract_origin: RB_SPECIAL_CONST_P)
    inlined_subroutine size=4 (abstract_origin: RBASIC_CLASS)
  inlined_subroutine size=106 (abstract_origin: vm_splat_array)
  inlined_subroutine size=29 (abstract_origin: vm_cc_valid_p)
  inlined_subroutine size=4 (abstract_origin: VM_ENV_FLAGS_SET)
```

## Project status

It works well on my x86\_64 Ubuntu 18.04 environment, but they aren't tested in other environments.

As I originally wanted to dig into only `subprogram` and `inlined_subroutine`, other DIEs have not been formatted well yet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

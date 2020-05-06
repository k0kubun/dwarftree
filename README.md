# Dwarftree

A wrapper of `objdump --dwarf=info` to visualize a structure of inlined subroutines

## Installation

```bash
$ gem install dwarftree
```

## Usage
### All subroutines

```bash
$ dwarftree /tmp/_ruby_mjit_p30080u145.so
...
```

### Single subroutine

```bash
$ dwarftree /tmp/_ruby_mjit_p30080u145.so _mjit141
...
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

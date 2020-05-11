class Dwarftree::DebugRangesParser
  CommandError = Class.new(StandardError)

  # @param [String] object
  def self.parse(object)
    cmd = ['objdump', '--dwarf=Ranges', object]
    debug_ranges = IO.popen(cmd, &:read)
    unless $?.success?
      raise CommandError.new("Failed to run: #{cmd.join(' ')}")
    end
    new.parse(debug_ranges)
  end

  # @param [String] debug_ranges
  # @return [Hash{ Integer => Array<Range<Integer>> }]
  def parse(debug_ranges)
    offset_ranges = Hash.new { |h, k| h[k] = [] }
    debug_ranges.scan(/^    \h{8} \h{16} \h{16} $/) do |line|
      offset, range_beg, range_end = line.strip.split(' ')
      offset_ranges[offset.to_i(16)] << (range_beg.to_i(16)..range_end.to_i(16))
    end
    offset_ranges
  end
end

module Dwarftree
  require 'dwarftree/debug_info_parser'

  def self.run(object, symbol:)
    begin
      units = DebugInfoParser.parse(object)
    rescue DebugInfoParser::ParserError => e
      abort "ERROR: #{e.message}"
    end
  end
end

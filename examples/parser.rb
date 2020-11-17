require_relative '../lib/querylet/parser'

parser  = Querylet::Parser.new

# Parslet parsers output deep nested hashes.
deep_nested_hash = parser.parse "{{#object}}this is a test{{/object}}"
puts deep_nested_hash

require_relative '../lib/querylet/parser'

parser  = Querylet::Parser.new
results = parser.parse "{{#object}}this is a test{{/object}}"
puts results

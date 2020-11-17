require_relative '../lib/querylet/parser'
require_relative '../lib/querylet/transform'
require_relative '../lib/querylet/tree'

parser    = Querylet::Parser.new
transform = Querylet::Transform.new

#content = "{{#object}}this is a test{{/object}}"
content = 'testing'

# parser
deep_nested_hash = parser.parse(content)
puts "parser:"
puts deep_nested_hash

# trasnform
abstract_syntax_tree  = transform.apply deep_nested_hash
puts "transform:"
puts abstract_syntax_tree


abstract_syntax_tree.eval()

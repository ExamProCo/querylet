require_relative 'querylet/parser'
require_relative 'querylet/transform'
require_relative 'querylet/tree'
require_relative 'querylet/template'
require_relative 'querylet/context'

module Querylet
  class Querylet
    include Context
    def initialize(path:)
      @sql_path = path
    end

    def compile(content)
      parser    = Parser.new
      transform = Transform.new
      #puts "parser.parse"
      deep_nested_hash = parser.parse_with_debug(content)
      #puts deep_nested_hash
      abstract_syntax_tree = transform.apply deep_nested_hash
      #puts abstract_syntax_tree
      Template.new self, abstract_syntax_tree
    end

    def set_context(ctx)
      @data = ctx
    end

    def get_partial name, dot_path
      path = @sql_path + '/' + dot_path.to_s.split('.').join('/') + '.sql'
      template = File.read(path).to_s.chomp
      self.compile(template).call(@data)
    end
  end # class Querylet
end # module Querylet

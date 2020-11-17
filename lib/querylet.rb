require_relative 'querylet/parser'
require_relative 'querylet/transform'
require_relative 'querylet/tree'
require_relative 'querylet/template'

module Querylet
  class Querylet
    def initialize()
    end

    def compile(template)
      Template.new(self, template_to_ast(template))
    end
  end
end

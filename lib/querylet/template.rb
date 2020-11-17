#require_relative 'context'

module Querylet
  class Template
    def initialize(querylet, ast)
      @querylet = querylet
      @ast = ast
    end

    def call(args = nil)
      if args
        @querylet.set_context(args)
      end

      # AST should return a Querylet::Tree and call its eval method
      @ast.eval(@querylet)
    end
  end
end

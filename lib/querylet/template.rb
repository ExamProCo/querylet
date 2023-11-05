require_relative 'context'

module Querylet
  class Template
    def initialize(querylet, ast)
      @querylet = querylet
      @ast = ast
    end

    # In Ruby, the call method is used to invoke a block, proc, or lambda, 
    # which are all different types of callable objects in Ruby.
    #
    # This is how querylet will get called in a developers code.
    #
    # querylet = Querylet::Querylet.new path: 'path/to/sql'
    # querylet.compile(template).call(data)
    # @args is the initial values passed to the template
    def call(args = nil)
      ctx = Context.new(@querylet, args)

      # AST should return a Querylet::Tree and call its eval method
      @ast.eval(ctx)
    end
  end # Template
end # Querylet
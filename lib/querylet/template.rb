#require_relative 'context'

module Querylet
  class Querylet
    def initialize(qlet, ast)
      @qlet = qlet
      @ast = ast
    end

    def call(args = nil)
      #if args
        #@qlet.set_context(args)
      #end

      @ast.eval(@qlet)
    end # def call
  end # class Querylet
end # module Querylet

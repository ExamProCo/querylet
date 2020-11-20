require_relative 'querylet/parser'
require_relative 'querylet/transform'
require_relative 'querylet/tree'
require_relative 'querylet/template'
require_relative 'querylet/context'
require_relative 'querylet/helper'
require_relative 'querylet/helpers'

module Querylet
  class Querylet
    include Context
    def initialize(path:)
      @sql_path = path
      @helpers = {}
      register_default_helpers
    end

    def compile(content)
      parser    = Parser.new
      transform = Transform.new
      #puts "compile: #{content}"
      deep_nested_hash = parser.parse(content)
      #puts deep_nested_hash
      abstract_syntax_tree = transform.apply deep_nested_hash
      #puts abstract_syntax_tree
      Template.new self, abstract_syntax_tree
    end

    def set_context(ctx)
      @data = ctx
    end

    def get_helper(name)
      @helpers[name.to_s]
    end

    def register_helper(name, &fn)
      @helpers[name.to_s] = Helper.new(self, fn)
    end

    def get_partial name, dot_path
      path = @sql_path + '/' + dot_path.to_s.split('.').join('/') + '.sql'
      template = File.read(path).to_s.chomp
      self.compile(template).call(@data)
    end

    def get_variable key
      @data[key.to_sym]
    end

    private
    def register_default_helpers
      self.register_helper :include        , &(Helpers.method(:helper_include).to_proc)
      self.register_helper :paginate       , &(Helpers.method(:helper_paginate).to_proc)
      self.register_helper :paginate_offset, &(Helpers.method(:helper_paginate_offset).to_proc)
      self.register_helper :wildcard       , &(Helpers.method(:helper_wildcard).to_proc)
      self.register_helper :quote          , &(Helpers.method(:helper_quote).to_proc)
      self.register_helper :int            , &(Helpers.method(:helper_int).to_proc)
      self.register_helper :float          , &(Helpers.method(:helper_float).to_proc)
      self.register_helper :array          , &(Helpers.method(:helper_array).to_proc)
      self.register_helper :object         , &(Helpers.method(:helper_object).to_proc)
    end

  end # class Querylet
end # module Querylet

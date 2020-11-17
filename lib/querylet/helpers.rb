# default helpers
module Querylet
  class Helpers
    def self.helper_include context, name, options
      puts "MonsterQueries::Query.helper_include"
      vars = {}
      context.each do |k,v|
        vars[k] = v
      end
      options['hash'].each do |k,v|
        vars[k] = v
      end if options
      parts = name.split('.')
      MonsterQueries::Builder.with_scope(parts).to_s vars
    end

    def self.helper_paginate context, value, options
      puts "MonsterQueries::Query.helper_paginate"
      if value.is_a?(String)
        count = !!context["count"]
        name = count ? 'pagination.select' : value
        self.helper_include context, name, options
      else
        value.fn context
      end
    end

    def self.helper_paginate_offset context, value, options
      puts "MonsterQueries::Query.helper_paginate_offset"
      self.helper_include context, 'pagination.offset', options
    end

    def self.helper_wildcard context, value, options
      puts "MonsterQueries::Query.helper_wildcard"
      ::ActiveRecord::Base.connection.quote "%#{value.gsub('\\','\\\\\\')}%"
    end

    def self.helper_quote context, value, options
      puts "MonsterQueries::Query.helper_quote"
      if value.is_a?(V8::Array)
        value.collect{|v| ::ActiveRecord::Base.connection.quote v}.join(',')
      else
        ::ActiveRecord::Base.connection.quote value
      end
    end

    def self.helper_int context, value, options
      value.to_i
    end

    def self.helper_float context, value, options
      value.to_f
    end

    def self.helper_array context, block, options
      content =
      if block.is_a?(String)
        "\n" + helper_include(context, block, options)
      else
        block.fn context
      end
      <<-HEREDOC
(SELECT COALESCE(array_to_json(array_agg(row_to_json(array_row))),'[]'::json) FROM (
#{content}
) array_row)
      HEREDOC
    end

    def self.helper_object context, block, options
      content =
      if block.is_a?(String)
        "\n" + helper_include(context, block, options)
      else
        block.fn context
      end
      <<-HEREDOC
(SELECT COALESCE(row_to_json(object_row),'{}'::json) FROM (
#{content}
) object_row)
      HEREDOC
    end
  end
end

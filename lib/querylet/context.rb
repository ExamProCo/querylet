module Querylet
  module Context
    def get(value)
      @data.merge(locals)[value.to_sym]
    end

    def add_item(key, value)
      locals[key.to_sym] = value
    end

    def add_items(hash)
      hash.map { |k, v| add_item(k, v) }
    end

    def with_temporary_context(args = {})
      saved = args.keys.collect { |key| [key, get(key.to_s)] }.to_h

      add_items(args)
      block_result = yield
      locals.merge!(saved)

      block_result
    end

    private

    def locals
      @locals ||= {}
    end
  end
end

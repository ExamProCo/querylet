module Querylet
  class Tree < Parslet::Transform
    class TreeItem < Struct
      def eval(context)
        _eval(context)
      end
    end

    class TemplateContent < TreeItem.new(:content)
      def _eval(context)
        return content
      end
    end

    class Variable < TreeItem.new(:item)
      def _eval(context)
        if context.get_helper(item.to_s).nil?
          context.get(item.to_s)
        else
          context.get_helper(item.to_s).apply(context)
        end
      end
    end

    class String < TreeItem.new(:content)
      def _eval(context)
        return content
      end
    end

    class Parameter < TreeItem.new(:name)
      def _eval(context)
        if name.is_a?(Parslet::Slice)
          context.get(name.to_s)
        else
          name._eval(context)
        end
      end
    end

    class Helper < TreeItem.new(:name, :parameters, :block, :else_block)
      def _eval(context)
        helper = context.get_helper(name.to_s)
        if helper.nil?
          context.get_helper('helperMissing').apply(context, String.new(name.to_s))
        else
          helper.apply(context, parameters, block, else_block)
        end
      end
    end

    class EscapedHelper < Helper
      def _eval(context)
        context.escaper.escape(super(context).to_s)
      end
    end

    class Partial < TreeItem.new(:partial, :path, :parameters)
      def _eval(context)
        [parameters].flatten.map(&:values).map do |vals|
          context.add_item vals.first.to_s, vals.last._eval(context)
        end
        context.get_partial partial.to_s, path
      end
    end

    class IfBlock < TreeItem.new(:if_kind, :variable, :items)
      def _eval(context)
        if if_kind == 'if'
          if context.get_variable(variable)
            items.map {|item| item._eval(context)}.join()
          end
        elsif if_kind == 'unless'
          unless context.get_variable(variable)
            items.map {|item| item._eval(context)}.join()
          end
        end
      end
    end

    class IfElseBlock < TreeItem.new(:if_kind, :variable, :items, :else_items)
      def _eval(context)
        if if_kind == 'if'
          if context.get_variable(variable)
            items.map {|item| item._eval(context)}.join()
          else
            else_items.items.map {|item| item._eval(context)}.join()
          end
        elsif if_kind == 'unless'
          unless context.get_variable(variable)
            items.map {|item| item._eval(context)}.join()
          else
            else_items.items.map {|item| item._eval(context)}.join()
          end
        end
      end
    end

    class Block < TreeItem.new(:items)
      def _eval(context)
        items.map {|item| item._eval(context)}.join()
      end
      alias :fn :_eval

      def add_item(i)
        items << i
      end
    end

  end
end

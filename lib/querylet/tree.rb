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

    class Replacement < TreeItem.new(:item)
      def _eval(context)
        if context.get_helper(item.to_s).nil?
          context.get(item.to_s)
        else
          context.get_helper(item.to_s).apply(context)
        end
      end
    end

    class EscapedReplacement < Replacement
      def _eval(context)
        context.escaper.escape(super(context).to_s)
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

  end
end

require_relative 'tree'

module Querylet
  class Transform < Parslet::Transform
    rule(content: simple(:content)) {
      Tree::TemplateContent.new(content)
    }

    rule(variable: simple(:item)) {
      Tree::Variable.new(item)
    }

    rule(string: simple(:content)) {
      Tree::String.new(content)
    }

    rule(
      if_kind: simple(:if_kind),
      if_variable: simple(:variable),
      items: subtree(:items),
      else_item: subtree(:else_items)
    ) {
      Tree::IfElseBlock.new(if_kind, variable, items, else_items)
    }

    rule(
      if_kind: simple(:if_kind),
      if_variable: simple(:variable),
      items: subtree(:items)
    ) {
      Tree::IfBlock.new(if_kind, variable, items)
    }

    rule(
      partial: simple(:partial),
      path: simple(:path),
      parameters: subtree(:parameters),
    ) {
      Tree::Partial.new(partial, path, parameters)
    }

    rule(
      filter: simple(:filter),
      parameter: subtree(:parameter)
    ) {
      Tree::Filter.new(filter,parameter)
    }

    rule(
      block: simple(:block),
      items: subtree(:items)
    ) {
      Tree::Block.new(block,items)
    }

    rule(items: subtree(:items)) {Tree::Items.new(items)}
  end
end


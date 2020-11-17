require_relative 'tree'

module Querylet
  class Transform < Parslet::Transform
    rule(template_content: simple(:content)) {Tree::TemplateContent.new(content)}
    rule(replaced_unsafe_item: simple(:item)) {Tree::EscapedReplacement.new(item)}
    rule(replaced_safe_item: simple(:item)) {Tree::Replacement.new(item)}
    rule(str_content: simple(:content)) {Tree::String.new(content)}
    rule(parameter_name: simple(:name)) {Tree::Parameter.new(name)}

    rule(
      unsafe_helper_name: simple(:name),
      parameters: subtree(:parameters)
    ) {
      Tree::EscapedHelper.new(name, parameters)
    }

    rule(
      safe_helper_name: simple(:name),
      parameters: subtree(:parameters)
    ) {
      Tree::Helper.new(name, parameters)
    }

    rule(
      helper_name: simple(:name),
      items: subtree(:items),
    ) {
      Tree::Helper.new(name, [], items)
    }

    rule(
      helper_name: simple(:name),
      items: subtree(:items),
      else_items: subtree(:else_items)
    ) {
      Tree::Helper.new(name, [], items, else_items)
    }

    rule(
      helper_name: simple(:name),
      parameters: subtree(:parameters),
      items: subtree(:items),
    ) {
      Tree::Helper.new(name, parameters, items)
    }

    rule(
      helper_name: simple(:name),
      parameters: subtree(:parameters),
    )
  end
end


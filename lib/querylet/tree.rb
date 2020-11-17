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
      block_items: subtree(:block_items),
    ) {
      Tree::Helper.new(name, [], block_items)
    }

    rule(
      helper_name: simple(:name),
      block_items: subtree(:block_items),
      else_block_items: subtree(:else_block_items)
    ) {
      Tree::Helper.new(name, [], block_items, else_block_items)
    }

    rule(
      helper_name: simple(:name),
      parameters: subtree(:parameters),
      block_items: subtree(:block_items),
    ) {
      Tree::Helper.new(name, parameters, block_items)
    }

    rule(
      helper_name: simple(:name),
      parameters: subtree(:parameters),
    )
  end
end

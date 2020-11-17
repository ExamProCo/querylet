require 'parslet'
require 'parslet/convenience'

module Querylet
  class Parser < Parslet::Parser
    # Every parser has a root. This designates where parsing should start.
    # It is like an entry point to your parser.
    root :document

    # "|" is an Alternation which is the equivlent of an OR operator
    # .repeat means to match repeatly the following atoms
    rule(:document) { item.repeat.as(:items) }

    rule(:item) { ifelse | block | partial | filter | variable | content }

    # {{ indentifer parameter }}
    rule(:filter) {
      docurly >>
      space? >>
      id.as(:filter) >>
      (space? >> parameter.as(:parameter)) >>
      space? >>
      dccurly
    }

    rule(:partial) {
      docurly >>
      space? >>
      gt >>
      space? >>
      id.as(:partial) >>
      space? >>
      path >>
      space? >>
      (
        parameter_kv >>
        space?
      ).repeat.as(:parameters) >>
      space? >>
      dccurly
    }

    rule(:block){
      docurly >>
      space? >>
      hash >>
      space? >>
      id.capture(:block).as(:block) >>
      space? >>
      dccurly >>
      space? >>
      scope {
        document
      } >>
      dynamic { |src, scope|
        docurly >> space? >> slash >> space? >> str(scope.captures[:block]) >> space? >> dccurly
      }
    }

    rule(:ifelse){
      # {{#if variable}}
      docurly >>
      space? >>
      hash >>
      if_kw.as(:if_kind) >>
      space? >>
      id.as(:if_variable) >>
      space? >>
      dccurly >>

      scope {
        document
      } >>

      scope {
        docurly >>
        space? >>
        slash >>
        space? >>
        else_kw >>
        space? >>
        dccurly >>
        scope { document.as(:else_item) }
      }.maybe >>

      # {{/if}}
      docurly >>
      space? >>
      slash >>
      if_kw >>
      space? >>
      dccurly
    }

    # {{ indentifer }}
    rule(:variable) { docurly >> space? >> id.as(:variable) >> space? >> dccurly}

    # Can either be a variable or a string:
    rule(:parameter)   { id.as(:variable) | string }

    # used in includes eg. hello='world'
    rule(:parameter_kv) {
      id.as(:key) >> 
      space? >>
      eq >>
      space? >>
      string.as(:value) >>
      space?
    }

    rule(:content) {
      (
        nocurly.repeat(1) | # A sequence of non-curlies
        ocurly >> nocurly | # Opening curly that doesn't start a {{}}
        ccurly            | # Closing curly that is not inside a {{}}
        ocurly >> eof       # Opening curly that doesn't start a {{}} because it's the end
      ).repeat(1).as(:content) 
    }

    rule(:space)       { match('\s').repeat(1) }
    rule(:space?)      { space.maybe }
    rule(:dot)         { str('.') }
    rule(:gt)          { str('>')}
    rule(:eq)          { str('=')}
    rule(:hash)        { str('#')}
    rule(:slash)       { str('/')}

    rule(:if_kw)     { str('if') | str('unless') }
    rule(:else_kw)     { str('else') }

    # Open Curled Bracket eg. "{"
    rule(:ocurly)      { str('{')}

    # Closed Cured Bracket eg. "}"
    rule(:ccurly)      { str('}')}

    # Double Open Curled Bracked eg. "{{"
    rule(:docurly)     { ocurly >> ocurly }

    # Double Closed Curled Bracked eg. "}}"
    rule(:dccurly)     { ccurly >> ccurly }

    rule(:id)  { match['a-zA-Z0-9_'].repeat(1) }
    rule(:path)        { match("'") >> (id >> (dot >> id).repeat).as(:path) >> match("'") }

    rule(:nocurly)     { match('[^{}]') }
    rule(:eof)         { any.absent? }

    # String contained in Single Qoutes 'content'
    rule(:string)   { match("'") >> match("[^']").repeat(1).as(:string) >> match("'") }
  end
end

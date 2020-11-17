## Querylet

#Variables

{{my_variable}}

#Partials

{{>include 'link.to.path' param='{{testing}}'}}

#Partial blocks
{{#array}}
{{/array}}

# If Else
{{#if variable}}
{{else}}
{{/end}}

## Parslet

https://www.youtube.com/watch?time_continue=873&v=ET_POMJNWNs&feature=emb_title
https://kschiess.github.io/parslet/parser.html
https://www.rubydoc.info/github/kschiess/parslet/Parslet/Atoms/Scope

https://www.rubydoc.info/github/kschiess/parslet/Parslet/Atoms/Capture

# Extra input after last repetition
https://stackoverflow.com/questions/27095141/how-do-i-get-my-parser-atom-to-terminate-inside-a-rule-including-optional-spaces


# Parset Slice

str('Boston').parse('Boston') #=> "Boston"@0

The @0 is the offset


https://www.sitepoint.com/parsing-parslet-gem/

# Parset Debugging

require 'parslet/convenience'
parser.parse_with_debug(input)

## Running test suite

The best way to get an understanding of the snytax is taking a look at
the `parser_helper.rb`.

You can run the tests with the following command.

```
rspec spec/parser_helper.rb
```

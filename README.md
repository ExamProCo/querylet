# Querylet

## Variable Filters
 
### Int (Integer)

Cast variable to integer

```
{{int my_number}}
```

### Str (String)

Cast variable to string

```
{{str my_string}}
```

### Float

Cast variable to float

```
{{float my_number}}
```

### Arr (Array)

Cast to array (not a postgres array)

```
{{arr my_array}}
```

### Wild (Wildcard)

Wildcard front and back of string

```
{{wild my_string}}
```




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

If the parser.rb runs into errors you can add the following to help
debug what is happening

```rb
require 'parslet/convenience'
parser.parse_with_debug(input)
```

### How it works:

* parser.rb    — Create a grammar: What should be legal syntax?
* transform.rb — Annotate the grammar: What is important data?
* tree.rb      - Create a transformation: How do I want to work with that data?

## Parser

Parslet parsers output deep nested hashes.

To see all the define rules check out `parser_helper.rb`

```
rspec spec/parser_helper.rb
```

## Transform

You capture patterns in your deep nested hash and the pass to a tree

## Tree

The tree does something with your captured patterns




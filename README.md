# Querylet

Querylet is a templating language for SQL
and is designed to make writing raw SQL much easier.

```sql
SELECT
  questions.id,
  questions.uuid,
  questions.question_html as question,
  questions.target_type as kind,
  {{#object}}
  SELECT
    case_study_questions.menu,
    case_study_questions.questions_pool_size,

    CASE {{str sub_question_type}}
    WHEN 'MultiChoiceQuestion' THEN
      {{> object 'questions.multiple_choice' id='{{sub_question_id}}' }} as question
    WHEN 'MultiSelectQuestion' THEN
      {{> object 'questions.multiple_select' id='{{sub_question_id}}' }} as question
    END,

    {{#array}}
      SELECT
        que.id,
        que.uuid,
        que.target_type as kind,
        choices.comment,
        choices.flagged,
        choices.choice_value as answered,
        multiple_select_questions.answers_count
      FROM ts_admin_que.questions que
      LEFT JOIN public.choices ON choices.question_id = que.id AND choices.attempt_id = {{id}}
      LEFT JOIN ts_admin_que.multiple_select_questions ON multiple_select_questions.id = que.target_id AND que.target_type = 'MultipleSelectQuestion'
      WHERE
        que.id = ANY(case_study_questions.question_ids)
    {{/array}} as questions
  {{/object}} as case_study
FROM ts_admin_que.questions
LEFT JOIN ts_admin_que.case_study_questions ON case_study_questions.question_id = questions.id
WHERE
  questions.id = {{id}}
```

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

### Variables

```
{{my_variable}}
```

### Partials

```
{{> include 'link.to.path' name='andrew' }}
{{> include 'link.to.path' name={{my_name}} }}
{{> include 'link.to.path' name={{str my_name}} }}
```

### Partial blocks

```
{{#array}}
{{/array}}
```

### If Else

```
{{#if variable}}
{{else}}
{{/end}}
```

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

To see all the define rules check out `parser_spec.rb`

```
bundle exec rspec spec/parser_spec.rb
```

## Transform

You capture patterns in your deep nested hash and the pass to a tree

## Tree

The tree does something with your captured patterns




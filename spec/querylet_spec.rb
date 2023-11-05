require_relative '../lib/querylet'
require 'pry'

describe Querylet::Querylet do
  let(:querylet) {Querylet::Querylet.new path: File.expand_path('./') }

  def evaluate(template, data = {})
    querylet.compile(template).call(data)
  end

  context 'evaluating' do
    it 'a dummy template' do
      expect(evaluate('My simple template')).to eq('My simple template')
    end

    it 'a simple replacement' do
      expect(evaluate('Hello {{name}}', {name: 'world'})).to eq('Hello world')
    end

    it 'a double braces replacement with nil' do
      expect(evaluate('Hello {{name}}', {name: nil})).to eq('Hello ')
    end

    context 'helpers' do
      it 'include' do
        query = "(SELECT users.email FROM users WHERE users.id = 1) as email"
        expect(evaluate("({{> include 'examples.include' }}) as email")).to eq(query)
      end

      it 'include with variables' do
        query = "(SELECT users.email FROM users WHERE users.id = 100) as email"
        template = "({{> include 'examples.include_with_vars' }}) as email"
        expect(evaluate(template, {id: 100})).to eq(query)
      end

      it 'include with parameters' do
        query = "(SELECT users.email, 'andrew' as name FROM users WHERE users.id = 200) as email"
        template = "({{> include 'examples.include_with_params' id='200' name='andrew' }}) as email"
        expect(evaluate(template, {id: 100})).to eq(query)
      end

      it 'include with parameters variable' do
        query = "(SELECT users.email FROM users WHERE users.id = 300) as email"
        template = "({{> include 'examples.include_with_params_vars' id={{user_id}} name='andrew' }}) as email"
        expect(evaluate(template, {user_id: 300})).to eq(query)
      end

      it 'include with parameters filter' do
        query = "(SELECT users.email, 'Andrew' as name FROM users WHERE users.id = 100) as email"
        template = "({{> include 'examples.include_with_params_filter' name={{str my_name}} }}) as email"
        expect(evaluate(template, {my_name: "Andrew", id: 100})).to eq(query)
      end

      it 'variable overrides' do
        query = "(SELECT questions.id, (SELECT que.id FROM questions que WHERE que.id = 555) as sub FROM questions WHERE questions.id = 100"
        template = "(SELECT questions.id, ({{> include 'examples.vars_overrides_include' xid={{sub_id}} }}) as sub FROM questions WHERE questions.id = {{xid}}"
        expect(evaluate(template, {sub_id: 555, xid: 100})).to eq(query)
      end

      it 'object' do
query = <<-SQL.chomp
(SELECT COALESCE(row_to_json(object_row),'{}'::json) FROM (
SELECT
  users.id,
  users.email
FROM users
WHERE
  users.id = 1
) object_row) as user
SQL
        output = evaluate("{{> object 'examples.object' }} as user")
        expect(output).to eq(query)
      end

      it 'array' do
query = <<-SQL.chomp
(SELECT COALESCE(array_to_json(array_agg(row_to_json(array_row))),'[]'::json) FROM (
SELECT
  users.id,
  users.email
FROM users
) array_row) as users
SQL
        output = evaluate("{{> array 'examples.array' }} as users")
        expect(output).to eq(query)
      end

      it 'if block' do
        template = "{{#if user_id }}yes{{/if}}"
        expect(evaluate(template, {user_id: true})).to eq('yes')
      end

      it 'unless block' do
        template = "{{#unless user_id }}yes{{/unless}}"
        expect(evaluate(template, {user_id: nil})).to eq('yes')
      end

      it 'if else block' do
        template = "{{#if user_id }}yes{{/else}}no{{/if}}"
        expect(evaluate(template, {user_id: false})).to eq('no')
      end

      it 'array block' do
query = <<-SQL.chomp
(SELECT COALESCE(array_to_json(array_agg(row_to_json(array_row))),'[]'::json) FROM (
yes
) array_row)
SQL
        template = "{{#array}}yes{{/array}}"
        expect(evaluate(template)).to eq(query)
      end

      it 'object block' do
query = <<-SQL.chomp
(SELECT COALESCE(row_to_json(object_row),'{}'::json) FROM (
yes
) object_row)
SQL
        template = "{{#object}}yes{{/object}}"
        expect(evaluate(template)).to eq(query)
      end

      it 'int filter' do
        template = "{{int user_id}}"
        expect(evaluate(template,{user_id: 2})).to eq('2')
      end

      it 'float filter' do
        template = "{{float user_id}}"
        expect(evaluate(template,{user_id: 2.2})).to eq('2.2')
      end

      it 'arr filter' do
        template = "{{arr ids}}"
        expect(evaluate(template,{ids: [1,2,3,4,5]})).to eq("1,2,3,4,5")
      end

      it 'arr filter' do
        template = "{{arr values}}"
        expect(evaluate(template,{values: ['hello','world']})).to eq("'hello','world'")
      end

      it 'str filter' do
        template = "{{str world}}"
        expect(evaluate(template,world: 'banana')).to eq("'banana'")
      end

      it 'wildcard filter' do
        template = "{{wild email}}"
        expect(evaluate(template,{email: 'andrew@exampro.co'})).to eq("'%andrew@exampro.co%'")
      end

    end # context 'helpers'
 end # context 'evaluating'
end

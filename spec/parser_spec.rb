require_relative '../lib/querylet/parser'
require 'pry'

RSpec.describe Querylet::Parser do
  let(:parser) {Querylet::Parser.new() }

  context 'recognizes' do
    it 'content' do
      expect(parser.parse('Deep Space Nine')).to eq({items:[{content: 'Deep Space Nine'}]})
    end

    it 'string' do 
      expect(parser.parse_with_debug("(SELECT COALESCE(row_to_json(object_row),'{}'::json) FROM (")).to eq({items:[{content: "(SELECT COALESCE(row_to_json(object_row),'{}'::json) FROM ("}]})
    end
    it 'variable' do
      expect(parser.parse('{{worf}}')).to eq({items:[{variable: 'worf'}]})
      expect(parser.parse('{{ worf}}')).to eq({items:[{variable: 'worf'}]})
      expect(parser.parse('{{worf }}')).to eq({items:[{variable: 'worf'}]})
      expect(parser.parse('{{ worf }}')).to eq({items:[{variable: 'worf'}]})
    end

    it 'filter' do
      expect(parser.parse('{{ quote worf }}')).to eq({items:[{
        filter: 'quote',
        parameter: {variable: 'worf'}
      }]})

      expect(parser.parse("{{ quote 'worf' }}")).to eq({items:[{
        filter: 'quote',
        parameter: {string: 'worf'}
      }]})
    end

    it 'partial' do
      expect(parser.parse("{{> include 'path.to.template' }}")).to eq({items:[{
        partial: 'include',
        path: 'path.to.template',
        parameters: []
      }]})

      expect(parser.parse("{{> include 'path.to.template' hello='world'}}")).to eq({items:[{
        partial: 'include',
        path: 'path.to.template',
        parameters: [
          {key: 'hello', value: {string: 'world'}}
        ]
      }]})

      expect(parser.parse("{{> include 'path.to.template' hello='world' star='trek' }}")).to eq({items:[{
        partial: 'include',
        path: 'path.to.template',
        parameters: [
          {key: 'hello', value: {string: 'world'}},
          {key: 'star', value: {string: 'trek'}}
        ]
      }]})
    end

    it 'block' do
      results = parser.parse("{{#object}}this is a test{{/object}}")
      expect(results).to eq({items:[
        { block: 'object', items: [{ content: 'this is a test' }] }
      ]})
    end

    it 'if' do
      results = parser.parse("{{#if hello}} this is true {{/if}}")
      expect(results).to eq(
        {:items=>[{:if_kind=>"if", :if_variable=>"hello", :items=>[{:content=>" this is true "}]}]}
      )
    end

    it 'ifelse' do
      results = parser.parse_with_debug("{{#unless hello}}true{{/else}}false{{/if}}")
      expect(results).to eq(
       {:items=>[{:else_item=>{:items=>[{:content=>"false"}]}, :if_kind=>"unless", :if_variable=>"hello", :items=>[{:content=>"true"}]}]}
      )
    end
  end # context 'recognizes' do
end

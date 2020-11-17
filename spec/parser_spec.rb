require_relative '../lib/querylet/parser'
require 'pry'

RSpec.describe Querylet::Parser do
  let(:parser) {Querylet::Parser.new}

  context 'recognizes' do
    it 'content' do
      expect(parser.parse('Deep Space Nine')).to eq([{content: 'Deep Space Nine'}])
    end

    it 'variable' do
      expect(parser.parse('{{worf}}')).to eq([{variable: 'worf'}])
      expect(parser.parse('{{ worf}}')).to eq([{variable: 'worf'}])
      expect(parser.parse('{{worf }}')).to eq([{variable: 'worf'}])
      expect(parser.parse('{{ worf }}')).to eq([{variable: 'worf'}])
    end

    it 'filter' do
      expect(parser.parse('{{ quote worf }}')).to eq([{
        filter: 'quote',
        parameter: {variable: 'worf'}
      }])

      expect(parser.parse("{{ quote 'worf' }}")).to eq([{
        filter: 'quote',
        parameter: {string: 'worf'}
      }])
    end

    it 'partial' do
      expect(parser.parse("{{> include 'path.to.template' }}")).to eq([{
        partial: 'include',
        path: 'path.to.template',
        parameters: []
      }])

      expect(parser.parse_with_debug("{{> include 'path.to.template' hello='world'}}")).to eq([{
        partial: 'include',
        path: 'path.to.template',
        parameters: [
          {key: 'hello', value: {string: 'world'}}
        ]
      }])

      expect(parser.parse("{{> include 'path.to.template' hello='world' star='trek' }}")).to eq([{
        partial: 'include',
        path: 'path.to.template',
        parameters: [
          {key: 'hello', value: {string: 'world'}},
          {key: 'star', value: {string: 'trek'}}
        ]
      }])
    end

    it 'block' do
      results = parser.parse("{{#object}}this is a test{{/object}}")
      expect(results).to eq([
        { block: 'object' },
        { content: 'this is a test' }
      ])
    end

    it 'if' do
      results = parser.parse("{{#if hello}} this is true {{/if}}")
      expect(results).to eq([
        { if_variable: 'hello', if_kind: 'if'  },
        { content: ' this is true ' }
      ])
    end

    it 'ifelse' do
      results = parser.parse_with_debug("{{#unless hello}}true{{/else}}false{{/if}}")
      expect(results).to eq([
        { if_variable: 'hello', if_kind: 'unless' },
        { content: 'true' },
        { else_item: [{ content: 'false' }]}
      ])
    end
  end # context 'recognizes' do
end

require_relative '../lib/querylet'
require 'pry'

describe Querylet::Querylet do
  let(:querylet) {Querylet::Querylet.new}

  def evaluate(template, args = {})
    querylet.compile(template).call(args)
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
      it 'simple' do
        expect(evaluate("Hello {{> include 'path.to.template' }}")).to eq("Hello Plic")
      end

    end # context 'partials'
    context 'helpers' do
    end # context 'helpers'
  end # context 'evaluating'
end

require_relative '../lib/querylet'
require 'pry'

describe Querylet::Querylet do
  let(:qlet) {Querylet::Querylet.new}

  def evaluate(template, args = {})
    qlet.compile(template).call(args)
  end

  context 'evaluating' do
    it 'a dummy template' do
      expect(evaluate('My simple template')).to eq('My simple template')
    end


    context 'partials' do
    end # context 'partials'
    context 'helpers' do
    end # context 'helpers'
  end # context 'evaluating'
end

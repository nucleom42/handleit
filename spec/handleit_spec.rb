# frozen_string_literal: true

require 'spec_helper'

describe Handle do
  class Service
    class << self
      def some_cool_logic
        'some_cool_string'
      end

      def error_raiser
        raise StandardError, 'raiser'
      end
    end
  end
  
  describe '.it .with .result' do
    context 'when call service some_cool_logic method' do
      it 'returns concatenated string' do
        expect(Handle.it{ Service.some_cool_logic }
                     .with{ |res, bla: 'bla'| "#{res} bla #{bla}" }
                     .with{ |res, lab: 'lab'| "#{res} lab #{lab}" }
                     .result)
          .to eq('some_cool_string bla bla lab lab')
      end
    end
    
    context 'when pipelining with lambda' do
      subject do
        size_minus_one = ->(str) { str.size - 1 }
        split_first = ->(str) { str.upcase.split.first }
        Handle.it { "Elixir rocks" }.with { |res| split_first.call(res) }.with { |res| size_minus_one.call(res) } 
      end
      
      it 'result method returns calculated value' do
        expect(subject.result).to eq(5)
      end
      
      it 'success method returns true' do
        expect(subject.success?).to be_truthy
      end

      it 'error method returns nil' do
        expect(subject.error).to be_nil
      end
    end

    context 'when call service error_raiser method' do
      it 'saves raiser string to @var' do
        @var = '.it .with .on_fail .result'
        expect(Handle.it{ Service.error_raiser }
                     .with{ |res| "#{res} bla" }
                     .with{ |res| "#{res} lab" }
                     .on_fail{|e| @var = e.message }
                     .result)
          .to be_nil
        expect(@var).to eq "raiser"
      end
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

describe LB::Operation, '#call' do
  subject { object.call(*args) }

  let(:args)   { [] }
  let(:object) { described_class.new }

  let(:expected_result) { 'called' }

  let(:error) { 'Override Operation#call(*args)!' }

  let(:child_class) do
    Class.new(described_class) do
      setting :foo, :bar
    end
  end

  let(:child_class_with_call) do
    klass = child_class.dup
    klass.class_eval do
      def call
        'called'
      end
    end
    klass
  end

  it 'should raise NotImplementedError when called without extending' do
    expect { subject }.to raise_error(NotImplementedError, error)
  end

  context 'with child class' do
    let(:object) { child_class.new }

    it 'should raise NotImplementedError when called without '\
       'overwriting call' do
      expect { subject }.to raise_error(NotImplementedError, error)
    end
    context 'and overwritten call method' do
      let(:object) { child_class_with_call.new }

      it 'should return "called"' do
        expect(subject).to eq(expected_result)
      end

      context 'and multiple arguments' do
        let(:child_class_with_call) do
          klass = child_class.dup
          klass.class_eval do
            def call(a, b, c)
              a + b + c
            end
          end
          klass
        end
        let(:args) { %w(ca ll ed) }

        it 'should return "called"' do
          expect(subject).to eq(expected_result)
        end
      end
    end
  end
end

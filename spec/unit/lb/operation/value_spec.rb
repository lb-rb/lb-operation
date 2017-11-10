# frozen_string_literal: true
require 'spec_helper'

describe LB::Operation, '#value' do
  subject { object.value(*args) }

  let(:object) { object_class.new }

  let(:args) { [] }

  let(:expected_result) { 'called' }

  let(:object_class) do
    Class.new(described_class) do
      def call
        'called'
      end
    end
  end

  it 'should return "called"' do
    expect(subject).to eq(expected_result)
  end

  context 'with value' do
    let(:object_class) do
      Class.new(described_class) do
        def call
          Struct.new(:value).new('called')
        end
      end
    end

    it 'should return "called"' do
      expect(subject).to eq(expected_result)
    end

    context 'with arguments' do
      let(:args) { %w(ca ll ed) }

      let(:object_class) do
        Class.new(described_class) do
          def call(a, b, c)
            Struct.new(:value).new(a + b + c)
          end
        end
      end

      it 'should return "called"' do
        expect(subject).to eq(expected_result)
      end
    end
  end
end

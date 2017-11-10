# frozen_string_literal: true
require 'spec_helper'

describe LB::Operation, '#handle_exception' do
  subject { object.handle_exception(error) }

  let(:object) { described_class.with_logger(logger).new }

  let(:error) { {} }

  let(:logger) do
    Class.new do
      def error(message)
        message
      end
    end.new
  end

  it 'should return self' do
    expect(subject).to be(object)
  end

  context 'with value' do
    let(:inspect_value) { double(:inspect) }
    let(:backtrace) { Struct.new(:inspect).new(inspect_value) }
    let(:message) { double(:message) }

    let(:exception) { Struct.new(:message, :backtrace).new(message, backtrace) }
    let(:error) { { exception: exception } }

    it 'should log' do
      LB::Operation.with_logger(logger)

      expect(object).to receive(:log)
        .at_least(:once)
        .with(:error, message)
        .ordered
      expect(object).to receive(:log)
        .at_least(:once)
        .with(:error, inspect_value)
        .ordered

      subject
    end

    it 'should return self' do
      expect(subject).to be(object)
    end
  end
end

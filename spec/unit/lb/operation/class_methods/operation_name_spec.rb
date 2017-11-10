# frozen_string_literal: true
require 'spec_helper'

describe LB::Operation, '.operation_name' do
  subject { object.operation_name }

  let(:object) do
    Class.new(described_class) do
      setting :name, :foo
    end
  end

  it 'should return :foo' do
    expect(subject).to eq(:foo)
  end
end

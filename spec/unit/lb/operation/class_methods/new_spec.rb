# frozen_string_literal: true
require 'spec_helper'

describe LB::Operation, '.new' do
  subject { object.new }

  let(:object) { described_class }

  it 'should be instance of LB::Operation' do
    expect(subject).to be_instance_of(object)
  end
end

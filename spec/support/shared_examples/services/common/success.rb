# frozen_string_literal: true

shared_examples_for 'services/common/success' do
  it 'looks like success' do
    expect(service).to be_success
  end

  it 'has no errors' do
    expect(service.errors).to be_empty
  end
end

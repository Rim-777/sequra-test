shared_examples_for 'services/common/failure' do
  it 'looks like failure' do
    expect(service).to be_failure
  end

  it 'contains errors' do
    expect(service.errors).to eq(expected_errors)
  end
end

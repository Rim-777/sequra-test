# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many(:merchant_orders).inverse_of(:merchant).dependent(:destroy) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:started_at) }
  it { should validate_presence_of(:disbursement_frequency) }
  it { should validate_presence_of(:minimum_monthly_fee) }

  describe 'email uniqueness validations' do
    subject { create(:merchant) }

    it { should validate_uniqueness_of(:email) }
  end
end

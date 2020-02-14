require 'rails_helper'

RSpec.describe Trip, type: :model do
  it '有効なファクトリを持つこと' do
    expect(FactoryBot.create(:trip)).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
end

# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    it 'nilだった時、basetitleのみ返すこと' do
      expect(full_title(nil)).to eq 'Trilog'
    end

    it 'emptyだった時、basetitleのみ返すこと' do
      expect(full_title('')).to eq 'Trilog'
    end

    it '正しいfulltitleを返すこと' do
      expect(full_title('Test')).to eq 'Test-Trilog'
    end
  end
end

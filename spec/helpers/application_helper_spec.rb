require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do
  describe '#text_url_to_link' do
    it 'httpがついていればハイパーリンクで返すこと' do
      text = "http://example.com"
      expect(text_url_to_link(text)).to have_link
    end

    it 'httpsがついていればハイパーリンクで返すこと' do
      text = "https://example.com"
      expect(text_url_to_link(text)).to have_link
    end

    it 'httpがついていなければリンクにならないこと' do
      text = "リンクなしテキスト"
      expect(text_url_to_link(text)).not_to have_link
    end

    it 'httpのついたURLの後にテキストがあるときURLのみハイパーリンクで返すこと' do
      text = "http://example.com テキスト"
      expect(text_url_to_link(text)).to have_link 'http://example.com', href: 'http://example.com'
      expect(text_url_to_link(text)).not_to have_link 'テキスト'
    end
  end

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

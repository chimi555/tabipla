require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do
  describe '#text_url_to_link' do
    example 'httpがついていればハイパーリンクで返すこと' do
      text = "http://example.com"
      expect(text_url_to_link(text)).to have_link
    end

    example 'httpsがついていればハイパーリンクで返すこと' do
      text = "https://example.com"
      expect(text_url_to_link(text)).to have_link
    end

    example 'httpがついていなければリンクにならないこと' do
      text = "リンクなしテキスト"
      expect(text_url_to_link(text)).not_to have_link
    end

    example 'httpのついたURLの後にテキストがあるときURLのみハイパーリンクで返すこと' do
      text = "http://example.com テキスト"
      expect(text_url_to_link(text)).to have_link 'http://example.com', href: 'http://example.com'
      expect(text_url_to_link(text)).not_to have_link 'テキスト'
    end
  end

  describe '#full_title' do
    example 'nilだった時、basetitleのみ返すこと' do
      expect(full_title(nil)).to eq 'tabipla'
    end

    example 'emptyだった時、basetitleのみ返すこと' do
      expect(full_title('')).to eq 'tabipla'
    end

    example '正しいfulltitleを返すこと' do
      expect(full_title('Test')).to eq 'Test-tabipla'
    end
  end
end

module ApplicationHelper
  require "uri"

  def text_url_to_link(text)
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      link_text = ""
      link_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, link_text)
    end

    text
  end

  def full_title(page_title = '')
    base_title = 'tabipla'
    if page_title.blank?
      base_title
    else
      page_title + '-' + base_title
    end
  end
end

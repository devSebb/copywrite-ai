class WebScraperService
  require "nokogiri"
  require "httparty"

  def initialize(url)
    @url = url
  end

  def scrape
    response = HTTParty.get(@url)
    raise "Failed to fetch the page" unless response.success?

    parsed_page = Nokogiri::HTML(response.body)

    # Remove footer if it exists
    footer = parsed_page.at_css("footer")
    footer.remove if footer

    # Remove navbar and menu content
    nav_elements = parsed_page.css('nav, header, [class*="nav"], [class*="menu"], [id*="nav"], [id*="menu"]')
    nav_elements.each(&:remove)

    text = parsed_page.css("body").text
    text.squeeze(" ").strip
  end
end

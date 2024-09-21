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
    text = parsed_page.xpath("//body//text()").map(&:text).join(" ")
    text.squeeze(" ").strip
  end
end

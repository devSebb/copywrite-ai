class ScraperController < ApplicationController
  def index
  end

  def scrape
    url = params[:url]

    if valid_url?(url)
      begin
        response = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(response.body)
        # Extract all text within the body tag
        @scraped_text = parsed_page.xpath("//body//text()").map(&:text).join(" ").squeeze(" ").strip
      rescue => e
        @error = "An error occurred while scraping: #{e.message}"
      end
    else
      @error = "Please enter a valid URL."
    end

    render :index
  end

  def improve_text
    scraped_text = params[:scraped_text]
    copywrite_service = CopywriteService.new(scraped_text)
    @improved_text = copywrite_service.improve_text
    render :index
  end

  private

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end

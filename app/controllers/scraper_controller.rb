class ScraperController < ApplicationController
  def index
  end

  def scrape
    url = params[:url]
    if valid_url?(url)
      begin
        scraper_service = WebScraperService.new(url)
        @scraped_text = scraper_service.scrape
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
    copywrite_service = CopywriteServices.new(scraped_text)
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

require "open-uri"
require "nokogiri"

class ThumbnailExtractor
  def self.extract(url)
    begin
      html = URI.open(url,
                      "User-Agent" => "Mozilla/5.0"
      ).read

      document = Nokogiri::HTML(html)

      # Try og:image first
      og_image = document.at('meta[property="og:image"]')

      return og_image["content"] if og_image

      # Fallback to twitter:image
      twitter_image = document.at('meta[name="twitter:image"]')

      return twitter_image["content"] if twitter_image

      nil
    rescue => e
      Rails.logger.error("Thumbnail extraction failed: #{e.message}")
      nil
    end
  end
end

require 'kimurai'
require 'open-uri'
require 'nokogiri'

# html = URI.open("https://sendage.com/user/natashabeaulac")
# response = Nokogiri::HTML(html)
# p response

class Scraper < Kimurai::Base
  @name= 'sendlist_scraper'
  @start_urls = ["https://sendage.com/user/sam-4529"]
  @engine = :selenium_chrome

  @@sends = []

  def scrape_page
    doc = browser.current_response
    returned_sends = doc.css('ul#sendlist')
    returned_sends.css('li').each do |char_element|
      name = char_element.css('.info span a')[0].text.chomp
      location = char_element.css('span.ui-sendlist-climb-location').text.chomp
      grade = char_element.css('.grade span')[0].text.chomp
      comment = char_element.css('div.col.comments').text.chomp
      #rating = char_element.css('div.rating.colRight').text.chomp ###TODO: Need to fix, content is not in text but in which stars are lit up
      send = {name: name, location: location, grade: grade, comment: comment}
      p send
    end 
  end

  def parse(response, url:, data: {})
    scrape_page
    @@sends
  end
end

Scraper.crawl!
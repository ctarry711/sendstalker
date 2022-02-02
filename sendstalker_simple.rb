require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'json'
require 'net/http'

user = "christarry"
path = "https://sendage.com/user/#{user}"

uri = URI(path)

puts "fetching #{user} data..."

html = ""

Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  request = Net::HTTP::Get.new uri
  html = http.request request
end

puts "parsing data..."

doc = Nokogiri::HTML(html.body)
profile_pic_path = doc.css('.profilepic img')[0]['src']
p profile_pic_path

grade_hash = JSON.parse(File.read('app/helpers/grade.json'))

username = doc.css('.profile-info .col .top')[0].content
sendlist = JSON.parse CGI::unescape(doc.css('#sendlist')[0]["climbs"])

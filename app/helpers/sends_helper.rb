module SendsHelper

  def get(path)

    uri = URI(path)

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      request = Net::HTTP::Get.new uri
    
      return http.request request

    end

  end


  def scrape_sendage_sends(users, num_sends)

    require 'open-uri'
    require 'nokogiri'
    require 'cgi'
    require 'json'
    require 'net/http'

    all_sends = {}
    users.each do |user|
      puts "fetching #{user} data..."

      html = get("https://sendage.com/user/#{user}").body
      doc = Nokogiri::HTML(html)

      grade_hash = JSON.parse(File.read('app/helpers/grade.json'))
      
      username = doc.css('.profile-info .col .top')[0].content
      sendlist = JSON.parse CGI::unescape(doc.css('#sendlist')[0]["climbs"])

      all_sends[username] = []

      sendlist[0..num_sends].each do |climb|
        name = climb["Climb"]["name"]
        location = climb["Climb"]["area_id"]
        climb_type = climb["Climb"]["type"]
        grade = grade_hash[climb["UserClimb"]["grade_id"]][climb_type]
        send_type = climb["UserClimb"]["type"] 
        date = climb["UserClimb"]["day"]
        comment = climb["UserClimb"]["comments"]
        rating = climb["UserClimb"]["rating"]
        slug = climb["Climb"]["slug"]
        send = {name: name, location: location, climb_type: climb_type, grade: grade, send_type: send_type, date: date, rating: rating, comment: comment, slug: slug}
        all_sends[username] << send
      end
    end
    return all_sends
  end
end
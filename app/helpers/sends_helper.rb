module SendsHelper

  def get(path)

    uri = URI(path)

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      request = Net::HTTP::Get.new uri
    
      return http.request request

    end

  end

  def get_send_location(slug)
    puts "getting location names for: ", slug
    html = get("https://sendage.com/area/#{slug}").body
    doc = Nokogiri::HTML(html)
    area_list = []
    doc.css('.title .area_parent').each do |area|
      area_list << area[0].content
    end 
    puts "names are:", area_list
  end

  def scrape_sendage_sends(users, num_sends)
    all_sends = [{:username=>"Zach Watson", :name=>"Angeles Caminando Entre Nosotros", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12b", :send_type=>"onsight", :date=>"2022-01-27", :rating=>"0", :comment=>"", :slug=>"angeles-caminando-entre-nosotros-las-animas-salto-mexico"}, {:username=>"Zach Watson", :name=>"Corazon De Guera", :area_id=>"1415", :climb_type=>"sport", :grade=>"5.10c", :send_type=>"onsight", :date=>"2022-01-27", :rating=>"0", :comment=>"", :slug=>"corazon-de-guera-salto-mexico"}, {:username=>"Zach Watson", :name=>"I Vision", :area_id=>"1415", :climb_type=>"sport", :grade=>"5.11c", :send_type=>"onsight", :date=>"2022-01-27", :rating=>"0", :comment=>"", :slug=>"i-vision-salto-mexico"}, {:username=>"Zach Watson", :name=>"Pesadilla Nocturna", :area_id=>"1415", :climb_type=>"sport", :grade=>"5.12c", :send_type=>"onsight", :date=>"2022-01-27", :rating=>"0", :comment=>"", :slug=>"pesadilla-nocturna-salto-mexico"}, {:username=>"Zach Watson", :name=>"Alien tufa", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.11d", :send_type=>"flash", :date=>"2022-01-26", :rating=>"0", :comment=>"", :slug=>"alien-tufa-las-animas-salto-mexico"}, {:username=>"Kiersten Classen", :name=>"Con las manos en la Cosa", :area_id=>"86", :climb_type=>"sport", :grade=>"5.11a", :send_type=>"onsight", :date=>"2022-01-28", :rating=>"3", :comment=>"", :slug=>"con-las-manos-en-cosa-sella-spain"}, {:username=>"Kiersten Classen", :name=>"Kashba", :area_id=>"86", :climb_type=>"sport", :grade=>"5.11c", :send_type=>"redpoint", :date=>"2022-01-27", :rating=>"4", :comment=>"", :slug=>"kashba-sella-spain"}, {:username=>"Kiersten Classen", :name=>"Calienta Motores", :area_id=>"6097", :climb_type=>"sport", :grade=>"5.11d", :send_type=>"redpoint", :date=>"2022-01-24", :rating=>"4", :comment=>"", :slug=>"calienta-motores-reguchillo-jaen-andalucia-spain"}, {:username=>"Kiersten Classen", :name=>"Metamorfosis", :area_id=>"5517", :climb_type=>"sport", :grade=>"5.11c", :send_type=>"redpoint", :date=>"2022-01-24", :rating=>"5", :comment=>"Fun 3D climbing.", :slug=>"metamorfosis-reguchillo-spain"}, {:username=>"Kiersten Classen", :name=>"Formic Acid", :area_id=>"8967", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"onsight", :date=>"2019-12-10", :rating=>"3", :comment=>"Fun and delicate.", :slug=>"formic-acid-fisher-valley-cat-ba-island-vietnam"}, {:username=>"Sam Armstrong", :name=>"Bizarre Contact", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12b", :send_type=>"redpoint", :date=>"2022-01-25", :rating=>"0", :comment=>"Alex's last day!", :slug=>"bizarre-contact-las-animas-salto-mexico"}, {:username=>"Sam Armstrong", :name=>"Techo del tecolote", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-01-23", :rating=>"0", :comment=>"Cutloose beta ! ", :slug=>"techo-del-tecolote-cueva-tecolote-salto-mexico"}, {:username=>"Sam Armstrong", :name=>"Spider Love", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"flash", :date=>"2022-01-23", :rating=>"0", :comment=>"The route beside limestoner, aka missing hangar ", :slug=>"spider-love-cueva-tecolote-salto-mexico"}, {:username=>"Sam Armstrong", :name=>"El Tecolotito Extension", :area_id=>"7728", :climb_type=>"sport", :grade=>"5.12c", :send_type=>"redpoint", :date=>"2022-01-20", :rating=>"0", :comment=>"Great !", :slug=>"tecolotito-extension-boca-salto-mexico"}, {:username=>"Sam Armstrong", :name=>"Lounge Puppy", :area_id=>"7728", :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-01-20", :rating=>"0", :comment=>"Shoulda done this  quicker but hurt my shoulder going to the rest", :slug=>"lounge-puppy-boca-salto-mexico"}, {:username=>"Chris Tarry", :name=>"Spider Love", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"flash", :date=>"2022-01-23", :rating=>"3", :comment=>"", :slug=>"spider-love-cueva-tecolote-salto-mexico"}, {:username=>"Chris Tarry", :name=>"Tecolote", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-01-22", :rating=>"3", :comment=>"Pretty funky climb. More-so caving than rock climbing though. Not my favourite style.", :slug=>"tecolote-cueva-tecolote-salto-mexico"}, {:username=>"Chris Tarry", :name=>"Inferno De Dante", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.13c", :send_type=>"redpoint", :date=>"2022-01-19", :rating=>"5", :comment=>"First 13c! Three days of work, 8 goes total. I didn&rsquo;t bother working the extension but now wish I had. I will go back up for it at some point. ", :slug=>"inferno-de-dante-las-animas-salto-mexico"}, {:username=>"Chris Tarry", :name=>"Muchos Cornjulios", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"onsight", :date=>"2022-01-18", :rating=>"4", :comment=>"", :slug=>"muchos-cornjulios-las-animas-salto-mexico"}, {:username=>"Chris Tarry", :name=>"All Along the Watchtower", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.11c", :send_type=>"onsight", :date=>"2022-01-17", :rating=>"3", :comment=>"", :slug=>"all-along-watchtower-las-animas-salto-mexico"}]
    return all_sends.sort_by {|send| send[:date]}.reverse
    require 'open-uri'
    require 'nokogiri'
    require 'cgi'
    require 'json'
    require 'net/http'

    all_sends = []

    users.each do |user|
      puts "fetching #{user} data..."

      html = get("https://sendage.com/user/#{user}").body
      doc = Nokogiri::HTML(html)

      grade_hash = JSON.parse(File.read('app/helpers/grade.json'))
      
      username = doc.css('.profile-info .col .top')[0].content
      sendlist = JSON.parse CGI::unescape(doc.css('#sendlist')[0]["climbs"])

      sendlist[..num_sends-1].each do |climb|
        name = climb["Climb"]["name"]
        area_id = climb["Climb"]["area_id"]
        climb_type = climb["Climb"]["type"]
        grade = grade_hash[climb["UserClimb"]["grade_id"]][climb_type]
        send_type = climb["UserClimb"]["type"] 
        date = climb["UserClimb"]["day"]
        comment = climb["UserClimb"]["comments"]
        rating = climb["UserClimb"]["rating"]
        slug = climb["Climb"]["slug"]
        #location = get_send_location(slug)
        send = {username: username, name: name, area_id: area_id, climb_type: climb_type, grade: grade, send_type: send_type, date: date, rating: rating, comment: comment, slug: slug}
        all_sends << send
      end
    end
    p all_sends
    return all_sends.sort_by {|send| send[:date]}.reverse
  end
end
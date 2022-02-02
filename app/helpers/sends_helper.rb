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

  def scrape_sendage_sends(followees, num_sends)

    #Sample data. Comment this out when you want to pull the live data
    data = {:users=>[{:realname=>"Rufio", :username=>"rufio", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg"}, {:realname=>"Sam Armstrong", :username=>"sam-4529", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg"}, {:realname=>"Chris Tarry", :username=>"christarry", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150"}], :sends=>[{:realname=>"Rufio", :name=>"Hippy Bishop", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"2405", :climb_type=>"boulder", :grade=>"V4", :send_type=>"redpoint", :date=>"2022-01-31", :rating=>"2", :comment=>"Heinous until finding better beta. Mildly heinous thereafter... Took the slab quest straight up the middle of the boulder after the mantle.", :slug=>"hippy-bishop-happy-boulders-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"Cheap New Age Fix", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"1", :climb_type=>"boulder", :grade=>"V2", :send_type=>"onsight", :date=>"2022-01-31", :rating=>"4", :comment=>"", :slug=>"cheap-new-age-fix-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"The Flying Zebra", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"2405", :climb_type=>"boulder", :grade=>"V4", :send_type=>"redpoint", :date=>"2022-01-31", :rating=>"4", :comment=>"Actually super flowy and fun!", :slug=>"flying-zebra-happy-boulders-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"Bleached Bones Left", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"2405", :climb_type=>"boulder", :grade=>"V4", :send_type=>"redpoint", :date=>"2022-01-31", :rating=>"3", :comment=>"Ow... Fun traverse finish, but painful.", :slug=>"bleached-bones-left-happy-boulders-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"Molly", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"4694", :climb_type=>"boulder", :grade=>"V5", :send_type=>"redpoint", :date=>"2022-01-30", :rating=>"4", :comment=>"", :slug=>"molly-sad-boulders-bishop-ca-usa"}, {:realname=>"Sam Armstrong", :name=>"Scarface Extension", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12b", :send_type=>"flash", :date=>"2022-02-02", :rating=>"0", :comment=>"45m, kind of chossy at the top ", :slug=>"scarface-extension-las-animas-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"The Mind's Eye", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12b", :send_type=>"onsight", :date=>"2022-01-30", :rating=>"0", :comment=>"", :slug=>"minds-eye-las-animas-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"Bizarre Contact", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12b", :send_type=>"redpoint", :date=>"2022-01-25", :rating=>"0", :comment=>"Alex's last day!", :slug=>"bizarre-contact-las-animas-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"Techo del tecolote", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-01-23", :rating=>"0", :comment=>"Cutloose beta ! ", :slug=>"techo-del-tecolote-cueva-tecolote-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"Spider Love", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"flash", :date=>"2022-01-23", :rating=>"0", :comment=>"The route beside limestoner, aka missing hangar ", :slug=>"spider-love-cueva-tecolote-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"The Mind's Eye", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12b", :send_type=>"flash", :date=>"2022-01-30", :rating=>"3", :comment=>"", :slug=>"minds-eye-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Inferno De Dante Extension", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.13d", :send_type=>"redpoint", :date=>"2022-01-30", :rating=>"4", :comment=>"Super psyched! First of the grade! I ended up falling on the extension twice before finally getting it.", :slug=>"inferno-de-dante-extension-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Culo de la negra", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"onsight", :date=>"2022-01-25", :rating=>"4", :comment=>"", :slug=>"culo-de-negra-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Spider Love", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.12a", :send_type=>"flash", :date=>"2022-01-23", :rating=>"3", :comment=>"", :slug=>"spider-love-cueva-tecolote-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Tecolote", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7729", :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-01-22", :rating=>"3", :comment=>"Pretty funky climb. More-so caving than rock climbing though. Not my favourite style.", :slug=>"tecolote-cueva-tecolote-salto-mexico"}]}
    return data


    require 'open-uri'
    require 'nokogiri'
    require 'cgi'
    require 'json'
    require 'net/http'

    data = {users: [], sends: []}

    followees.each do |followee|
      username = followee.username
      puts "fetching #{username} data..."

      html = get("https://sendage.com/user/#{username}").body
      doc = Nokogiri::HTML(html)
      puts "processed html"

      grade_hash = JSON.parse(File.read('app/helpers/grade.json'))
      
      realname = doc.css('.profile-info .col .top')[0].content
      profile_pic_path = doc.css('.profilepic img')[0]['src']
      data[:users] << {realname: realname, username: username, profile_pic: profile_pic_path}

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
        send = {realname: realname, name: name, profile_pic: profile_pic_path, area_id: area_id, climb_type: climb_type, grade: grade, send_type: send_type, date: date, rating: rating, comment: comment, slug: slug}
        data[:sends] << send
      end
    end
    p data
    #return all_sends.sort_by {|send| send[:date]}.reverse
    return data
  end
end
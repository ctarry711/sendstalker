class ApplicationController < ActionController::Base
  def get_area_info(area_id)
    area_info = {"name"=> "", "parents"=> []}

    area = Area.find_by(area_id: area_id)
    if area
      area_info["name"] = area.area_name
      parents = parent_recursion(area, [])
      area_info["parents"] = parents
    else
      area_data = scrape_area_info(area_id)
      area_name = area_data["name"]
      area_id = area_data["id"]
      parent_id = area_data["parent_id"].to_i
      area_parents = area_data["parents"]
      new_area = Area.create(area_id: area_id, area_name: area_name, parent_id: parent_id)
      area_parents.each do |parent|
        new_area = Area.new(area_id: parent["id"].to_i, area_name: parent["name"], parent_id: parent["parent_id"])
        if new_area.save
          area_info["parents"] << parent["name"]
        end
      end
    end
    return area_info
  end

  def parent_recursion(area, parents)
    parent = Area.find_by(area_id: area.parent_id)
    if parent.nil? or parent.area_id == 5691
      return parents
    else
      parents << parent.area_name
      parent_recursion(parent, parents)
    end
  end
  
  def scrape_area_info(area_id)
    require "net/http"
    require 'json'
    require 'cgi'

    uri = URI("https://sendage.com/api/climbs")
    headers = {
        "accept": "application/json, text/javascript, */*; q=0.01",
        "accept-language": "en-US,en;q=0.9",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "sec-ch-ua": "\" Not;A Brand\";v=\"99\", \"Google Chrome\";v=\"97\", \"Chromium\";v=\"97\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"Windows\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "x-requested-with": "XMLHttpRequest",
        "cookie": "__utmz=45372454.1636139338.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.2.1519327461.1636139338; wordpress_logged_in_3811572f777979037a3eea8b7b1ddda7=christarry%7C1643491377%7CU6XYhcA15telqXtP4a5yA8P3hqbiDHyj1eWXXke2FOh%7C076161ee80e884e01e296015dc0a21a14be4c4322727ea73a30c3cb998ab2cf4; __utmc=45372454; SendageSession=ilap2gq87lbb49tgse2m1q3ie2; __utma=45372454.1519327461.1636139338.1643053939.1643227958.36; __utmt=1; fbm_155767311119657=base_domain=.sendage.com; fbsr_155767311119657=4pwP1WfAtHd25NhwM5QwY0ooLuTZx1icOvKaqb0i8ws.eyJ1c2VyX2lkIjoiMTAxNTU0MzIxMDQxNzEwMzgiLCJjb2RlIjoiQVFCTmtIT20zOTFCQjdWZUlZLXFaVVFEZHFhUVNzREVCZGJEMG9QRVRUZnRaUVliQ2JDV0dUTzE1dnJSMWhvZ1ozZXR1OENtTUZnWDllNkNzbUM0TVpiVndyam5QUUFvS1ZhVENkTGt1b0YyOC04bFpKSWxSV3ZkWTYxeGlVWE80ZVM5QzF1LWgtSUxUR3VoTTVGbWRzZ3ktMENXeVAzUS1HaW5kZGluUFZWYTNSS2hPYS14Rnowa2NuenBXdGhwZ25mQV8wRXZRVWhwMDZZN3ZXTHQ3QmVoLTFzVjZETnpSOXZpRHhiNEhnRzJHc2l5bmk4UHJtelZ2RHBac1Z2aUNCTnpXX19HRXFTZW5KMUYtT3B5LUE0TDdfSk1XZVNQVXpwU0ZDMlVBTTl6eWxwNGlJRmUyY1ExLTVYTTdEZHFDMmciLCJvYXV0aF90b2tlbiI6IkVBQUNOcTJjWkNOU2tCQUpZNmcwWkJOWkNwM2taQzhTdE5xRmRDMkozeVJ6UVVmRlFiclpDam9nYmM5WG5BQXQ2Rk9NYm0yRWtZNjBJbWNJNmRGcFlJV2U5azdRRmtGUUp0OVJwNWp1d2dXNEc4TjVxcXlHbFNhQVg2Um0wVVF0SFFJRGZieDN6QkxPaGlHMU9kOVFCRjNRbWhHYlBvU3M4dVFMdU9tSEt4ZXdpd1JkTmVrY1pDWSIsImFsZ29yaXRobSI6IkhNQUMtU0hBMjU2IiwiaXNzdWVkX2F0IjoxNjQzMjI3OTU4fQ; CakeCookie[FeedType]=Q2FrZQ%3D%3D.5gAkJ1gA%2BpI%3D; __utmb=45372454.2.10.1643227958; fbsr_155767311119657=4pwP1WfAtHd25NhwM5QwY0ooLuTZx1icOvKaqb0i8ws.eyJ1c2VyX2lkIjoiMTAxNTU0MzIxMDQxNzEwMzgiLCJjb2RlIjoiQVFCTmtIT20zOTFCQjdWZUlZLXFaVVFEZHFhUVNzREVCZGJEMG9QRVRUZnRaUVliQ2JDV0dUTzE1dnJSMWhvZ1ozZXR1OENtTUZnWDllNkNzbUM0TVpiVndyam5QUUFvS1ZhVENkTGt1b0YyOC04bFpKSWxSV3ZkWTYxeGlVWE80ZVM5QzF1LWgtSUxUR3VoTTVGbWRzZ3ktMENXeVAzUS1HaW5kZGluUFZWYTNSS2hPYS14Rnowa2NuenBXdGhwZ25mQV8wRXZRVWhwMDZZN3ZXTHQ3QmVoLTFzVjZETnpSOXZpRHhiNEhnRzJHc2l5bmk4UHJtelZ2RHBac1Z2aUNCTnpXX19HRXFTZW5KMUYtT3B5LUE0TDdfSk1XZVNQVXpwU0ZDMlVBTTl6eWxwNGlJRmUyY1ExLTVYTTdEZHFDMmciLCJvYXV0aF90b2tlbiI6IkVBQUNOcTJjWkNOU2tCQUpZNmcwWkJOWkNwM2taQzhTdE5xRmRDMkozeVJ6UVVmRlFiclpDam9nYmM5WG5BQXQ2Rk9NYm0yRWtZNjBJbWNJNmRGcFlJV2U5azdRRmtGUUp0OVJwNWp1d2dXNEc4TjVxcXlHbFNhQVg2Um0wVVF0SFFJRGZieDN6QkxPaGlHMU9kOVFCRjNRbWhHYlBvU3M4dVFMdU9tSEt4ZXdpd1JkTmVrY1pDWSIsImFsZ29yaXRobSI6IkhNQUMtU0hBMjU2IiwiaXNzdWVkX2F0IjoxNjQzMjI3OTU4fQ",
        "Referer": "https://sendage.com/area/lost-world-north-walls-squamish-bc-canada",
        "Referrer-Policy": "strict-origin-when-cross-origin"
      }

    #Not being used atm
    body = "mode=climb&page=1&term=&areas%5B%5D=5694&area_parents=false&order%5B%5D=sends+DESC&rating=0&sends=0&limit=15&types%5Bb%5D%5Bon%5D=1&types%5Bs%5D%5Bon%5D=1&types%5Bt%5D%5Bon%5D=1"

    ## area id's: "5692": "Canada", "8462": "Kenora", "5801": "Ontario", "5796": "Manitoba", "1": "Bishop"
    form_data = {'mode': "climb", 'page': "1", 'term': '','areas[]': area_id,'area_parents': 'false','order[]': 'sends DESC','rating': '','sends': '0','limit': '100','types[b][on]': '1','types[s][on]': '1','types[t][on]': '1'}
    
    puts "getting data for #{area_id}"
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(form_data)
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true, :read_timeout => 30) do |http|
      http.request(req)
    end

    response_parsed = JSON.parse CGI::unescape(res.body)
    data = response_parsed["areas"][0]["Area"]
    
    return data

  end

  def filler_data
    return {:users=>[{:id=>1,:realname=>"Rufio", :username=>"rufio", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg"}, {:id=>2,:realname=>"Sam Armstrong", :username=>"sam-4529", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg"}, {:id=>4, :realname=>"Chris Tarry", :username=>"christarry", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150"}, {:id=>5, :realname=>"Zach Watson", :username=>"zach-watson", :profile_pic=>"https://graph.facebook.com/100000104280082/picture?width=150&height=150"}, {:id=>6, :realname=>"Evan Hau", :username=>"evan-hau", :profile_pic=>"//sendage.com/img/user/profile-evan-hau-2-full.jpg"}], :sends=>[{:realname=>"Rufio", :name=>"Hippy Bishop", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"2405", :area_name=>"Happy Boulders", :area_parents=>["Bishop"], :climb_type=>"boulder", :grade=>"V4", :send_type=>"redpoint", :date=>"2022-01-31", :rating=>"2", :comment=>"Heinous until finding better beta. Mildly heinous thereafter... Took the slab quest straight up the middle of the boulder after the mantle.", :slug=>"hippy-bishop-happy-boulders-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"Cheap New Age Fix", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"1", :area_name=>"Happy Boulders", :area_parents=>["Bishop"], :climb_type=>"boulder", :grade=>"V2", :send_type=>"onsight", :date=>"2022-01-31", :rating=>"4", :comment=>"", :slug=>"cheap-new-age-fix-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"The Flying Zebra", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"2405", :area_name=>"Happy Boulders", :area_parents=>["Bishop"], :climb_type=>"boulder", :grade=>"V4", :send_type=>"redpoint", :date=>"2022-01-31", :rating=>"4", :comment=>"Actually super flowy and fun!", :slug=>"flying-zebra-happy-boulders-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"Bleached Bones Left", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"2405", :area_name=>"Happy Boulders", :area_parents=>["Bishop"], :climb_type=>"boulder", :grade=>"V4", :send_type=>"redpoint", :date=>"2022-01-31", :rating=>"3", :comment=>"Ow... Fun traverse finish, but painful.", :slug=>"bleached-bones-left-happy-boulders-bishop-ca-usa"}, {:realname=>"Rufio", :name=>"Molly", :profile_pic=>"//sendage.com/img/user/profile-rufio-3-full.jpeg", :area_id=>"4694", :area_name=>"Sad Boulders", :area_parents=>["Bishop"], :climb_type=>"boulder", :grade=>"V5", :send_type=>"redpoint", :date=>"2022-01-30", :rating=>"4", :comment=>"", :slug=>"molly-sad-boulders-bishop-ca-usa"}, {:realname=>"Sam Armstrong", :name=>"Scarface Extension", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12b", :send_type=>"flash", :date=>"2022-02-02", :rating=>"0", :comment=>"45m, kind of chossy at the top ", :slug=>"scarface-extension-las-animas-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"The Mind's Eye", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12b", :send_type=>"onsight", :date=>"2022-01-30", :rating=>"0", :comment=>"", :slug=>"minds-eye-las-animas-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"Bizarre Contact", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12b", :send_type=>"redpoint", :date=>"2022-01-25", :rating=>"0", :comment=>"Alex's last day!", :slug=>"bizarre-contact-las-animas-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"Techo del tecolote", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7729", :area_name=>"La Cueva Tecolote", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-01-23", :rating=>"0", :comment=>"Cutloose beta ! ", :slug=>"techo-del-tecolote-cueva-tecolote-salto-mexico"}, {:realname=>"Sam Armstrong", :name=>"Spider Love", :profile_pic=>"//sendage.com/community/wp-content/uploads/2018/07/Sam_avatar-100x100.jpg", :area_id=>"7729", :area_name=>"La Cueva Tecolote", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12a", :send_type=>"flash", :date=>"2022-01-23", :rating=>"0", :comment=>"The route beside limestoner, aka missing hangar ", :slug=>"spider-love-cueva-tecolote-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Bizarre Contact", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12b", :send_type=>"redpoint", :date=>"2022-02-05", :rating=>"2", :comment=>"es poopy", :slug=>"bizarre-contact-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Purigatorio", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-02-05", :rating=>"4", :comment=>"3rd go", :slug=>"purigatorio-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"scarface", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12a", :send_type=>"onsight", :date=>"2022-02-02", :rating=>"3", :comment=>"", :slug=>"scarface-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"Camino de Chino", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2022-02-02", :rating=>"4", :comment=>"Gave it a solid flash go but also had to hang draws and ended up not having enough gusto. Managed to get it second go though. Tried to continue up the extension, which I hadn't tried before but fell", :slug=>"camino-de-chino-las-animas-salto-mexico"}, {:realname=>"Chris Tarry", :name=>"The Mind's Eye", :profile_pic=>"https://graph.facebook.com/10155432104171038/picture?width=150&height=150", :area_id=>"7727", :area_name=>"Las Animas", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12b", :send_type=>"flash", :date=>"2022-01-30", :rating=>"3", :comment=>"", :slug=>"minds-eye-las-animas-salto-mexico"}, {:realname=>"Zach Watson", :name=>"Honey Bear", :profile_pic=>"https://graph.facebook.com/100000104280082/picture?width=150&height=150", :area_id=>"7728", :area_name=>"La Boca", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12a", :send_type=>"flash", :date=>"2022-01-30", :rating=>"0", :comment=>"", :slug=>"honey-bear-boca-salto-mexico"}, {:realname=>"Zach Watson", :name=>"Hijo de Puta", :profile_pic=>"https://graph.facebook.com/100000104280082/picture?width=150&height=150", :area_id=>"7728", :area_name=>"La Boca", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12b", :send_type=>"flash", :date=>"2022-01-30", :rating=>"0", :comment=>"", :slug=>"hijo-de-puta-boca-salto-mexico"}, {:realname=>"Zach Watson", :name=>"El Arte de Volar", :profile_pic=>"https://graph.facebook.com/100000104280082/picture?width=150&height=150", :area_id=>"7728", :area_name=>"La Boca", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12c", :send_type=>"flash", :date=>"2022-01-30", :rating=>"0", :comment=>"", :slug=>"arte-de-volar-boca-salto-mexico"}, {:realname=>"Zach Watson", :name=>"Soul Power", :profile_pic=>"https://graph.facebook.com/100000104280082/picture?width=150&height=150", :area_id=>"7729", :area_name=>"La Cueva Tecolote", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.12d", :send_type=>"onsight", :date=>"2022-01-29", :rating=>"0", :comment=>"", :slug=>"soul-power-cueva-tecolote-salto-mexico"}, {:realname=>"Zach Watson", :name=>"El Gallo de Oro", :profile_pic=>"https://graph.facebook.com/100000104280082/picture?width=150&height=150", :area_id=>"7729", :area_name=>"La Cueva Tecolote", :area_parents=>["North America", "Mexico", "El salto"], :climb_type=>"sport", :grade=>"5.13b", :send_type=>"onsight", :date=>"2022-01-29", :rating=>"0", :comment=>"", :slug=>"gallo-de-oro-cueva-tecolote-salto-mexico"}, {:realname=>"Evan Hau", :name=>"Echo", :profile_pic=>"//sendage.com/img/user/profile-evan-hau-2-full.jpg", :area_id=>"7607", :area_name=>"Echo Cave", :area_parents=>["Canada", "Alberta", "Bow Valley", "Echo Canyon"], :climb_type=>"sport", :grade=>"5.13a", :send_type=>"redpoint", :date=>"2021-10-22", :rating=>"4", :comment=>"", :slug=>"echo-echo-cave-echo-canyon-ab-canada"}, {:realname=>"Evan Hau", :name=>"No Surrender", :profile_pic=>"//sendage.com/img/user/profile-evan-hau-2-full.jpg", :area_id=>"9509", :area_name=>"Echo cave", :area_parents=>["Canada", "Alberta", "Bow Valley", "Echo Canyon", "The Lookout"], :climb_type=>"sport", :grade=>"5.14b", :send_type=>"redpoint", :date=>"2021-10-20", :rating=>"4", :comment=>"Great cave climb by Grzegorz Florek! This is probably my strongest style but it just didn't seem quite hard enough for 14c.", :slug=>"no-surrender-echo-cave-lookout-echo-canyon-ab-canada"}, {:realname=>"Evan Hau", :name=>"The Hand Party", :profile_pic=>"//sendage.com/img/user/profile-evan-hau-2-full.jpg", :area_id=>"7607", :area_name=>"Echo Cave", :area_parents=>["Canada", "Alberta", "Bow Valley", "Echo Canyon"], :climb_type=>"sport", :grade=>"5.12c", :send_type=>"onsight", :date=>"2021-10-08", :rating=>"4", :comment=>"", :slug=>"hand-party-echo-cave-echo-canyon-ab-canada"}, {:realname=>"Evan Hau", :name=>"Steep &amp Sweet", :profile_pic=>"//sendage.com/img/user/profile-evan-hau-2-full.jpg", :area_id=>"8247", :area_name=>"Vsion Wall", :area_parents=>["Canada", "Alberta", "Bow Valley", "Stoneworks Canyon"], :climb_type=>"sport", :grade=>"5.14c", :send_type=>"redpoint", :date=>"2021-09-13", :rating=>"5", :comment=>"I originally thought 14c but after breaking some holds and epiccing, it felt pretty hard in the end for me, let's say 14c/d.", :slug=>"steep-amp-sweet-vsion-wall-stoneworks-canyon-ab-canada"}, {:realname=>"Evan Hau", :name=>"City In The Sea", :profile_pic=>"//sendage.com/img/user/profile-evan-hau-2-full.jpg", :area_id=>"7542", :area_name=>"Solid Wall", :area_parents=>["Canada", "Alberta", "Banff National Park", "Raven's Crag"], :climb_type=>"sport", :grade=>"5.12d", :send_type=>"flash", :date=>"2021-08-21", :rating=>"3", :comment=>"", :slug=>"city-in-sea-solid-wall-ravens-crag-ab-canada"}]}
  end
end
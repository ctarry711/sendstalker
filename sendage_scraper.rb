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

page_index = 1 #Used to iterate through all pages since only 15 results are returned for each page
num_pages = 1

loop do
  if page_index > num_pages
    break
  end
  ## area id's: "5692": "Canada", "8462": "Kenora", "5801": "Ontario", "5796": "Manitoba", "1": "Bishop"
  form_data = {'mode': "climb", 'page': page_index.to_s, 'term': '','areas[]': '5692','area_parents': 'false','order[]': 'sends DESC','rating': '','sends': '0','limit': '15','types[b][on]': '1','types[s][on]': '1','types[t][on]': '1'}

  req = Net::HTTP::Post.new(uri)
  req.set_form_data(form_data)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true, :read_timeout => 30) do |http|
    http.request(req)
  end

  response_parsed = JSON.parse CGI::unescape(res.body)

  num_pages = (response_parsed["total"]/15.to_f).ceil #divide by 15 because each page containes 15 climbs
  puts "Total Pages:", num_pages

  climbs = response_parsed["climbs"]
  areas = response_parsed["areas"] 
  File.open("climbs.json", "w") {|f| f.write(climbs.to_json)}

  File.open("areas.json", "w") do |f|
    f.write(areas.to_json)
  end

  puts "Current Page:", page_index
  page_index += 1
end

require 'net/http'

net = Net::HTTP.new("http://www.hasbro.com", 8081)
request = Net::HTTP::Post.new("/scrabble/en_US/search.cfm")
request.set_form_data({"dictWord" => 'ugly'})
net.set_debug_output $stdout #useful to see the raw messages going over the wire
net.read_timeout = 10
net.open_timeout = 10


# request.set_form_data({"a_named_field" => some_object.to_json})
# request.add_field("X-API-KEY", "some api key or custom field")
# net.set_debug_output $stdout #useful to see the raw messages going over the wire
# net.read_timeout = 10
# net.open_timeout = 10

response = net.start do |http|
http.request(request)
end
puts response.code
puts response.read_body
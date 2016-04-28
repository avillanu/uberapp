require 'sinatra'
require 'httparty'
require 'pry'
require 'uri'
require 'dotenv'
Dotenv.load
get '/' do
  erb :index
end
post '/location' do
googleapi = ENV["google_geocoding_key"]
uberapi = ENV["uber_server_token"]
directionsapi = ENV["google_directions_key"]
@location1 = params[:location1]
@location2 = params[:location2]
@googlelink = "https://www.google.com/maps/embed/v1/directions?key=#{directionsapi}&origin=#{@location1}&destination=#{@location2}&avoid=tolls|highways&mode=driving"
uri = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{@location1}&key=#{googleapi}")
response = Net::HTTP.get_response(uri)
response2 = JSON.parse(response.body)

uri2 = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{@location2}&key=#{googleapi}")
response3 = Net::HTTP.get_response(uri2)
response4 = JSON.parse(response3.body)
  @lat1 = response2['results'][0]["geometry"]["location"]["lat"]
  @lng1 = response2['results'][0]["geometry"]["location"]["lng"]
  @lat2 = response4['results'][0]["geometry"]["location"]["lat"]
  @lng2 = response4['results'][0]["geometry"]["location"]["lng"]
uri3 = URI("https://api.uber.com/v1/estimates/price?server_token=#{uberapi}&start_latitude=#{@lat1}&start_longitude=#{@lng1}&end_latitude=#{@lat2}&end_longitude=#{@lng2}")
response5 = Net::HTTP.get_response(uri3)
response6 = JSON.parse(response5.body)
@fare = response6['prices'][1]['estimate']
@duration = response6['prices'][1]['duration']
@duration = @duration/60
@surge = response6['prices'][1]['surge_multiplier']
  erb :index
end

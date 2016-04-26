require 'sinatra'
require 'httparty'
require 'pry'
require 'uri'
require 'dotenv'

get '/' do
  erb :index
end
post '/location' do
@location1 = params[:location1]
@location2 = params[:location2]
@googlelink = "https://www.google.com/maps/embed/v1/directions?key=AIzaSyAizQCVgRDh-r19AJNTdX_XP3GsBV8uVk0&origin=#{@location1}&destination=#{@location2}&avoid=tolls|highways"
uri = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{@location1}&key=AIzaSyDxqqK4SVguPpCIH7fxD627TYS2iqRtHpY")
response = Net::HTTP.get_response(uri)
response2 = JSON.parse(response.body)

uri2 = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{@location2}&key=AIzaSyDxqqK4SVguPpCIH7fxD627TYS2iqRtHpY")
response3 = Net::HTTP.get_response(uri2)
response4 = JSON.parse(response3.body)
  @lat1 = response2['results'][0]["geometry"]["location"]["lat"]
  @lng1 = response2['results'][0]["geometry"]["location"]["lng"]
  @lat2 = response4['results'][0]["geometry"]["location"]["lat"]
  @lng2 = response4['results'][0]["geometry"]["location"]["lng"]

uri3 = URI("https://api.uber.com/v1/estimates/price?server_token=auRQ2fNlP5rXnlMKRVIT4rhHjcQWQjw79gCi_MOX&start_latitude=#{@lat1}&start_longitude=#{@lng1}&end_latitude=#{@lat2}&end_longitude=#{@lng2}")
response5 = Net::HTTP.get_response(uri3)
response6 = JSON.parse(response5.body)
@fare = response6['prices'][1]['estimate']
@duration = response6['prices'][1]['duration']
@duration = @duration/60
@surge = response6['prices'][1]['surge_multiplier']

  erb :index
end


get '/hi' do
  response = HTTParty.get('https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyDxqqK4SVguPpCIH7fxD627TYS2iqRtHpY')
  puts response['results'][0]["geometry"]["location"]["lat"]
  puts response['results'][0]["geometry"]["location"]["lng"]
end

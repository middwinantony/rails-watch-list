# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# require 'httparty'

# movies = HTTParty.get("https://tmdb.lewagon.com/movie/top_rated").parsed_response['results']

# movies.each do |movie_data|
#   Movie.create!(
#     title: movie_data['title'],
#     overview: movie_data['overview'],
#     poster_url: "https://image.tmdb.org/t/p/w500#{movie_data['poster_path']}",
#     rating: movie_data['vote_average']
#   )
# end

# puts "Seeded #{movies.size} movies!"

require 'net/http'
require 'json'

puts "Cleaning database..."
Movie.destroy_all

token = ENV['TMDB_API_KEY']
puts "Fetching movies from TMDB..."

(1..5).each do |page|
  uri = URI("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=#{page}")

  request = Net::HTTP::Get.new(uri)
  request["Authorization"] = "Bearer #{token}"
  request["accept"] = "application/json"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
  data = JSON.parse(response.body)

  next unless data["results"]

  data["results"].each do |movie_data|
    Movie.create!(
      title: movie_data["title"],
      overview: movie_data["overview"],
      rating: movie_data["vote_average"],
      poster_url: "https://image.tmdb.org/t/p/w500#{movie_data['poster_path']}"
    )
  end

  puts "Page #{page} done!"
end

puts "✅ Created #{Movie.count} movies!"

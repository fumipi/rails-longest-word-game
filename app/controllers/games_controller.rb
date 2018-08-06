require 'open-uri'
require 'json'
require 'net/http'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map{('a'..'z').to_a.sample.upcase}
  end

  def score
    @letters = params[:letters].split
    @attempt = params[:word]
    api_result_hash = JSON.parse(Net::HTTP.get(URI.parse("https://wagon-dictionary.herokuapp.com/#{@attempt}")))
    attempt = @attempt.upcase.split("")
    @letters.each do |letter|
      if attempt.include?(letter)
        attempt = attempt - [letter]
      end
    end
    if attempt == [] && api_result_hash["found"] == true
      @message = "Congratulations! #{@attempt.upcase} is a valid English word!"
    elsif attempt != []
      @message = "Sorry but #{@attempt.upcase} can't be built out of #{@letters.join(",")}"
    else
      @message = "Sorry but #{@attempt.upcase} does not seem like a valid English word..."
    end
  end

end

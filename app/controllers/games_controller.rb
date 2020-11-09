require 'open-uri'
require 'json'

class GamesController < ApplicationController
    
    def new
      @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    end

    def score
        @attempt = params[:your_try] 
        @result = message(@attempt, @letters)
    end

    private

    def included?(guess, letters)
        guess.chars.all? { |letter| guess.count(letter) <= @letters.count(letter) }
    end
    
    def message(attempt, letters)
        if included?(attempt.upcase, letters)
          if english_word?(attempt)
            [score, "Congratulations! #{attempt} is a valid English word!"]
          else
            [0, "Sorry but #{attempt} can't be built out of #{letters}"]
          end
        else
          [0, "Sorry but #{attempt} does not seem to be a valid English Word"]
        end
      end
      
      def english_word?(word)
        response = open("https://wagon-dictionary.herokuapp.com/#{word}")
        json = JSON.parse(response.read)
        return json['found']
      end
end

require 'open-uri'

class GamesController < ApplicationController
  def new
    chars = [*('a'..'z')].flatten
    @letters = Array.new(10) { chars.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:letters]
    @result = run_game(@word, @grid)
    @score = @result[:score]
    @score += @result[:score]
    end
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_info = URI.open(url).read
    word = JSON.parse(word_info)
    result = { :score => 0, :message => "" }
    if word["found"] == true && in_grid?(attempt, grid) == true
      result[:message] = "Well done!"
      result[:score] = word["length"] * 5
    elsif word["found"] == false
      result[:message] = "Not an english word"
    else
      result[:message] = "Not in the grid"
    end
    result
  end

  def in_grid?(attempt, grid)
    sum = 0
    attempt_array = attempt.downcase.chars
    grid_array = grid.chars
    attempt_array.each do |character|
      sum += 1 if attempt_array.count(character) > grid_array.count(character)
    end
    sum.zero?
  end
end

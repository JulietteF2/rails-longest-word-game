require 'open-uri'

class GamesController < ApplicationController
  # def initialize
  #   @session = ActionDispatch::Session::CookieStore.new
  # end

  def new
    #session[:total_score] = "bob"
    #raise
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @attempt = params[:attempt]
    @attempt_as_array = @attempt.upcase.split('')
    @grid = params[:grid].gsub(/\W/, '').split('')
    @valid_to_grid = valid_letters?(@attempt_as_array, @grid)
    @valid_english = english_word?(@attempt)
    if @valid_to_grid && @valid_english
      session[:total_score] = 0 if session[:total_score].nil?

      session[:total_score] += @attempt.length * @attempt.length
    end
    # build a basic scoring system
  end

  def valid_letters?(attempt, grid)
    attempt_as_hash = Hash.new(0)
    grid_as_hash = Hash.new(0)
    attempt.each { |letter| attempt_as_hash[letter] += 1 }
    grid.each { |letter| grid_as_hash[letter] += 1 }
    return_boolean(attempt_as_hash, grid_as_hash)
  end

  def return_boolean(attempt_as_hash, grid_as_hash)
    result = true
    attempt_as_hash.each do |key, val|
      if grid_as_hash.key?(key)
        grid_as_hash[key] >= val ? next : result = false
      else result = false
      end
    end
    result
  end

  def english_word?(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/'
    filepath = url + attempt
    hash_answer = JSON.parse(open(filepath).read)
    hash_answer['found']
  end
end

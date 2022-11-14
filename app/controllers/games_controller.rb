class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.shuffle.first(rand(4..15))
  end

  def score
    @guess = params[:guess]
    letters = params[:letters].split
    @res = 'lost'
    return unless valid_letters?(@guess, letters) || english?(@guess)

    @res = 'won'
  end

  private

  def valid_letters?(word, letters)
    valid = true
    word.chars.each do |c|
      valid = letters.include? c
      letters.delete c if valid
      break unless valid
    end
    valid
  end

  def english?(word)
    res = RestClient.get("https://wagon-dictionary.herokuapp.com/#{word.strip}")
    data = JSON.parse(res.body)
    data['found']
  end
end

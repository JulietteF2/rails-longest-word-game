require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test 'Going to /new gives us a new random grid to play with' do
    visit new_url
    assert test: 'New game'
    assert_selector 'li', count: 10
  end

  test 'Filling the form with a random word, click play, should get a message that the word is not in the grid' do
    visit new_url
    fill_in 'attempt', with: 'zzzzzzzzzzzzzzzzz'

    click_on 'submit'
    assert_text "Sorry but ZZZZZZZZZZZZZZZZZ can't be built out of"
  end

  test 'Filling the form with a one-letter consonant word, click play, should get a message it’s not a valid English word' do
    visit new_url

    all('.letter').each do |letter|
      test_letter = letter.text if letter.text == /[^aeiou]/
      return test_letter
    end

    fill_in 'attempt', with: test_letter

    click_on 'submit'
    assert_text "Sorry but #{test_letter} does not seem to be a valid English word..."
  end
end

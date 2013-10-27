require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.hasbro.com'


class WordSearchResults
  attr_accessor :complete, :word, :definition
  
  def complete?
    false
  end
  
  def word?
    false
  end
end

def search_for(word)
  visit "/scrabble/en_US/search.cfm"
  
  fill_in "dictWord", :with => word
  find(:css, "#exact").set(true)
  click_button("btn_search")

  if word_found?(word)
    puts "found #{word}!"
  else
    puts "could not find #{word}!"
  end
end

def word_found?(word)
  !page.has_content? "0 words found."
end

search_for('ugly')
search_for("asdfasdfsadf")
search_for('art')

# res1 = WordSearchResults.new
# res1.word = false
# res1.complete = true
# 
# puts "word comp? #{res1.complete}"
# puts "word word? #{res1.word}"


# 
# 
# 
# visit "/scrabble/en_US/search.cfm"
# 
# fill_in "dictWord", :with => "smelly"
# find(:css, "#exact").set(true)
# click_button("btn_search")
# 
# 
# odor = page.has_content?("having an unpleasant odor")
# other = page.has_content?("asdfasdfdsaf")
# 
# puts "has odor #{odor}"
# puts "has other #{other}"
# 



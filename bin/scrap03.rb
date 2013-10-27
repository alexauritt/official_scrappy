require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.hasbro.com'


class WordSearchResults
  attr_accessor :complete, :word, :definition, :points
  
  def complete?
    complete
  end
  
  def word?
    word
  end
end

def search_for(word)
  visit "/scrabble/en_US/search.cfm"
  
  fill_in "dictWord", :with => word
  find(:css, "#exact").set(true)
  click_button("btn_search")

  results = WordSearchResults.new
  results.complete = true

  
  if word_found?(word)
    match_data = extract_definition
    results.word = true
    results.points = match_data[2]
    results.definition = match_data[4]
  else
    results.word = false
  end
  results
end

def word_found?(word)
  !page.has_content? "0 words found."
end

def extract_definition
  
  #SMOKE [11 pts] , (SMOKED/SMOKING/SMOKES) to emit smoke (the gaseous product of burning materials) -- SMOKABLE

  # will break down to...

  # 1.  SMOKE
  # 2.  11
  # 3.  (SMOKED/SMOKING/SMOKES)
  # 4.   to emit smoke (the gaseous product of burning materials)
  # 5.  -- SMOKABLE

  definition_reg_ex = /([A-Z]+) \[(\d+) pts\] , (\(\S*\))([^-]*)(-- .*)?/
  
  within("#dictionary") do
    results = page.all('p', :text => /.*/)
    word_results_string = results[1].text
    word_results_string.match definition_reg_ex
  end
end

def perform_sample_searches!
  # search_for('ugly')
  res = search_for("asdfasdfsadf")
  puts "asdfasdf: #{res.word?}"

  res = search_for('art')
  puts "art: #{res.word?}"
  puts "art: #{res.definition}"

  res = search_for('foot')
  puts "foot: #{res.word?}"
  puts "foot: #{res.definition}"

  res = search_for('universe')
  puts "universal: #{res.word?}"
  puts "universal: #{res.definition}"  
end

perform_sample_searches!
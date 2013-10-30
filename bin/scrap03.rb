require 'logger'

require 'data_mapper'
require 'dm-migrations'

require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.hasbro.com'

class Token
  include DataMapper::Resource

  property :id,           Serial    # An auto-increment integer key
  property :token_string, String    # A varchar type string, for short strings
  property :is_word,      Boolean      # A text block, for longer string data.
  property :points,       Integer
  property :definition,   String
  property :created_at,   DateTime  # A DateTime, for any date you might like.

  validates_uniqueness_of :token_string
end




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
  definition_reg_ex = /([A-Z]+) \[(\d+) pts\] (, \(\S*\))?([^-]*)(-- .*)?/
  
  within("#dictionary") do
    results = page.all('p', :text => /.*/)
    word_results_string = results[1].text
    word_results_string.match definition_reg_ex
  end
end

def perform_sample_searches!
  # search_for('ugly')
  # res = search_for("asdfasdfsadf")
  # puts "asdfasdf: #{res.word?}"
  # 
  # res = search_for('art')
  # puts "art: #{res.word?}"
  # puts "art: #{res.definition}"
  # 
  # res = search_for('foot')
  # puts "foot: #{res.word?}"
  # puts "foot: #{res.definition}"

  res = search_for('ae')
  
  # puts "universal: #{res.word?}"
  # puts "universal: #{res.definition}"  
end

def setup_db!
  # A Sqlite3 connection to a persistent database
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/official_scraper.db")
  
  DataMapper.finalize
  DataMapper.auto_upgrade!
  
end

def search_and_save(token)
  word_search_results = search_for(token)
  if (word_search_results.word?)
    Token.create(
      :token_string => token,
      :is_word => true,
      :points => word_search_results.points,
      :definition => word_search_results.definition
    )
  else
    Token.create(
      :token_string => token,
      :is_word => false
    )
  end
end
# perform_sample_searches!

def get_it_done!
  setup_db!

  logger = Logger.new('log/search_history.log')

  letters = ('A' .. 'Z').to_a
  # logger.info "Beginning Two Letter Search.."
  # 
  # letters.each do |letter_1|
  #   letters.each do |letter_2|
  #     token = letter_1 + letter_2
  #     search_and_save(token)
  #     logger.info "finished #{token}"
  #   end
  # end
  
  logger.info "Beginning Three Letter Search"
  letters.each do |letter_1|
    letters.each do |letter_2|
      letters.each do |letter_3|
        token = letter_1 + letter_2 + letter_3
        if token > 'JCR'
          search_and_save(token)
          logger.info "finished #{token}"
        end
      end
    end
  end

  logger.info "FINISHED!"
end

# setup_db!
get_it_done!

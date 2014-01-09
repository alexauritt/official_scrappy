require 'logger'

require 'data_mapper'
require 'dm-migrations'

require './lib/token'
require './lib/word_search_results'
require './lib/definition_fetcher'

require 'capybara'
require 'capybara/dsl'
include Capybara::DSL

Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.hasbro.com'


def setup_db!
  # A Sqlite3 connection to a persistent database
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/official_scraper.db")
  
  DataMapper.finalize
  DataMapper.auto_upgrade!  
end

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
        if token > 'YOU'
          search_successful = false
          
          while !search_successful
            search_successful = DefinitionFetcher.search_and_save(token)
          end
          puts "finished with #{token}"
          logger.info "finished #{token}"
        end
      end
    end
  end

  logger.info "FINISHED!"
end

# setup_db!
get_it_done!

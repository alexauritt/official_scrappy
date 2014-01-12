require 'logger'
require './lib/persistor'
require './lib/token'
require './lib/word_search_results'
require './lib/definition_fetcher'

TokenScraping::Persistor.setup_db!
logger = Logger.new('log/search_history.log')
letters = ('A' .. 'Z').to_a
puts "Beginning Two Letter word Search.."

missing_tokens = []

letters.each do |letter_1|
  letters.each do |letter_2|
    token = letter_1 + letter_2
    results = Token.all(:token_string => token)
    if results.count < 1
      missing_tokens << token
      puts "Found #{results.count} for #{token}"
    end
  end
end

puts "Beginning Three Letter word Search.."

letters.each do |letter_1|
  letters.each do |letter_2|
    letters.each do |letter_3|
      token = letter_1 + letter_2 + letter_3

      results = Token.all(:token_string => token)
      if results.count < 1
        missing_tokens << token
        puts "Found #{results.count} for #{token}"
      end
    end
  end
end

puts "Now I have to find #{missing_tokens.count} tokens"

missing_tokens.each do |token|
  search_successful = false
  
  while !search_successful
    search_successful = TokenScraping::DefinitionFetcher.search_and_save(token)
  end
  puts "finished with #{token}"
  logger.info "finished #{token}"
end
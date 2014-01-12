require 'data_mapper'


def setup_db!
  # A Sqlite3 connection to a persistent database
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/official_scraper.db")
  
  DataMapper.finalize
  DataMapper.auto_upgrade!
  
end

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


setup_db!
letters = ('A' .. 'Z').to_a
puts "Beginning Two Letter word Search.."

missing_tokens = []

letters.each do |letter_1|
  letters.each do |letter_2|
    token = letter_1 + letter_2
    results = Token.all(:token_string => token)
    if results.count < 1
      missing_tokens << results
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
        missing_tokens << results
        puts "Found #{results.count} for #{token}"
      end
    end
  end
end

puts "#{missing_tokens}"
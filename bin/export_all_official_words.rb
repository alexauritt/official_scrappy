require 'logger'
require './lib/persistor'
require './lib/token'

  TokenScraping::Persistor.setup_db!

f = File.new("notes/official_word_list_from_hasbro.txt", 'w')
Token.all.each do |t|
	f.puts "#{t.token_string}" if t.is_word
end

f.close

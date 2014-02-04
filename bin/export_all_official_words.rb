require 'logger'
require './lib/persistor'
require './lib/token'

  TokenScraping::Persistor.setup_db!

f = File.new("notes/official_word_list_from_hasbro.txt", 'w')

real_words = Token.all.select(&:is_word)
real_word_strings = real_words.map(&:token_string)
real_word_strings.uniq!
real_word_strings.sort_by! {|word| [word.size, word] }
real_word_strings.each { |word| f.puts word }

f.close

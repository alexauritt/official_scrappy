require 'nokogiri'
require 'open-uri'

scrabble_url = "http://www.hasbro.com/scrabble/en_US/search.cfm"
doc = Nokogiri::HTML(open(scrabble_url))

word_input = doc.css("input#dictWord")
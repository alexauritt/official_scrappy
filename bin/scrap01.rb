require 'nokogiri'
require 'open-uri'

require 'mechanize'
agent = Mechanize.new

agent.get("http://www.hasbro.com/scrabble/en_US/search.cfm")
dict_form = agent.page.form("frmDict1")
dict_form.dictWord = 'axe'
dict_form.checkbox_with(:name => 'exact').check
puts "about to submit"
dict_form.submit
puts "after submit"

pp agent.page
# form = agent.page.forms

#### mechanize demos
# form.password = "secret"
# form.submit
# 
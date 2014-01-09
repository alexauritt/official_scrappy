class DefinitionFetcher
  def self.search_and_save(token)
    word_search_results = DefinitionFetcher.search_for(token)

    unless word_search_results.complete?
      puts "failed in searching for #{token}"
      return false
    end

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
    true
  end

  def self.search_for(word)
    results = WordSearchResults.new

    begin  
      visit "/scrabble/en_US/search.cfm"
      
      fill_in "dictWord", :with => word
      find(:css, "#exact").set(true)
      click_button("btn_search")  
      if valid_response_received?
        results.complete = true

        if word_found?(word)
          match_data = extract_definition
          results.word = true
          results.points = match_data[2]
          results.definition = match_data[4]
        else
          results.word = false
        end
      
      else
        results.complete = false
      end
    rescue
      results.complete = false
    end
    results
  end

  def self.valid_response_received?
    page.has_content? "words found."
  end

  def self.word_found?(word)
    !page.has_content? "0 words found."
  end

  def self.extract_definition
    
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
end


require 'data_mapper'
require 'dm-migrations'


module TokenScraping
	class Persistor
		def self.setup_db!
		  # A Sqlite3 connection to a persistent database
		  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/official_scraper.db")
		  DataMapper.finalize
		  DataMapper.auto_upgrade!  
		end

	end
end
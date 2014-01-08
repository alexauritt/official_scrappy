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


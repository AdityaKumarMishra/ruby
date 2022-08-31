class Autoemail < ActiveRecord::Base
  enum categories: [:get_clarity]
  enum greetings: ["Dear [Student First Name]"]
end

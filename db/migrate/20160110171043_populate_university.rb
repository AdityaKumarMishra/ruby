class PopulateUniversity < ActiveRecord::Migration[6.1]
  def change
    ['Australian Catholic University',
     'Australian National University',
     'Bond University',
     'Central Queensland University',
     'Charles Darwin University',
     'Curtin University',
     'Deakin University',
     'Edith Cowan University',
     'Flinders University',
     'Griffith University',
     'James Cook University',
     'La Trobe University',
     'Macquarie University',
     'Monash University',
     'Murdoch University',
     'Queensland University of Technology',
     'RMIT University',
     'Southern Cross University',
     'Swinburne University of Technology University',
     'University of Adelaide',
     'University of Ballarat',
     'University of Canberra',
     'University of Melbourne',
     'University of New England',
     'University of New South Wales',
     'University of Newcastle',
     'University of Notre Dame',
     'University of Queensland',
     'University of South Australia',
     'University of Southern Queensland',
     'University of Sydney',
     'University of Tasmania',
     'University of Technology Sydney',
     'University of the Sunshine Coast',
     'University of Western Australia',
     'University of Western Sydney',
     'University of Wollongong',
     'Victoria University',
     'Other'].each do |u|
      University.create(name: u)
    end
  end
end
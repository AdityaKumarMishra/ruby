require 'csv'
namespace :create_quote do
		task create_quote_theme: :environment do
			quote_theme_arr = ["Evil","Society","Truth","Progress","Justice","Mortality","Vice","Choice","Violence","Virtue","Politics","Nature","Passion","Art","Freedom","Wisdom","Travel","Health","Religion","Morality","Charity","Time","Bureaucracy","Knowledge","Love","Humour","Revenge","Gossip","Death","Success","Imagination","Wealth","Future","Happiness","Friendship","War","Punishment","Science","Technology","Crime","Poverty","Beauty","Youth","Ageing","Suffering","Originality","Conformity"]
			quote_theme_arr.each do |quote_theme|
				QuoteTheme.create(theme: quote_theme) unless QuoteTheme.find_by(theme: quote_theme).present?
				end
			end

		task create_quote_bank: :environment do 
			file_name = File.join Rails.root, "quotes.csv"
			CSV.foreach(file_name) do |row|
				quote, author, quote_theme = row
				quote_theme_id = QuoteTheme.find_by(theme: quote_theme.delete(' ')).id
				QuoteBank.create(quote: quote,author: author,quote_theme_id: quote_theme_id)
		end	
	end
end
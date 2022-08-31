module QuoteThemesHelper
	def random_theme
		offset = rand(QuoteTheme.count)
		@rand_record = QuoteTheme.offset(offset).first
		@rand_record.theme
	end

	def random_quote
		random_quote_arr = @rand_record.quote_banks.limit(5).order("RANDOM()")
		return random_quote_arr
	end
end

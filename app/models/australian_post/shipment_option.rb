class ShipmentOption
	def initialize(products, toPostcode)
		# We assumes products includes only PhysicalProducts
		@products = products
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'
		@toPostcode = toPostcode

		# Need to be changed
		@fromPostcode = '2000'
	end

	def calculate_cost
		parcelWeight = 0
		parcelHeight = 0
		parcelLength = 0
		parcelWidth = 0

		@products.each do |product|
			parcelWeight += product.weight
			parcelHeight += product.height
			parcelLength += product.length
			parcelWidth += product.width
		end

		queryParams = Hash.new(0)
		queryParams = {'from_postcode' => @fromPostcode,
										'to_postcode' => @toPostcode,
										'length' => parcelLength,
										'width' => parcelWidth,
										'height' => parcelHeight,
										'weight' => parcelWeight
									}

		urlPrefix = 'auspost.com.au'
		postageTypesURL = 'https://' + urlPrefix + '/api/v3/postage/domestic/service.json?' +
			queryParams.to_query

		result = RestClient::Request.new({ :method => :get,
			:url => postageTypesURL, headers: { 'AUTH-KEY' => @apikey } })
		JSON.parse(result.execute)
	end
end

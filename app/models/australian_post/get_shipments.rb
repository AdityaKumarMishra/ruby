class GetShipments
  def initialize(offset, number_of_shipments)
    @offset = offset
    @number_of_shipments = number_of_shipments
		@accountNumber = '1007948742'
		@apikey = '7103d5e0-ec02-41d9-b69a-9e3cdc23e338'

		# @urlPrefix = "digitalapi.auspost.com.au"
		@apiURL = "http://digitalapi.auspost.com.au/testbed/shipping/v1/shipments?offset=#{@offset}&number_of_shipments=#{@number_of_shipments}"
  end

  def list_shipments
    result = RestClient::Request.new({ :method => :get, :url => @apiURL,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
		JSON.parse(result.execute)
  end
end

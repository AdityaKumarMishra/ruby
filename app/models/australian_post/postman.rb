require 'base64'

# Checking requests to Australia Post with fixed data
class Postman
	def postnew
	@apikey = '68bf8347-28a0-4e30-b604-755fdad9cd65'
	@accountNumber = '1007948742'
	@apiURL = "https://digitalapi.auspost.com.au/testbed/shipping/v1/shipments"

	queryParams = Hash.new(0)
	# queryParams = {
	# 									"shipment_reference" => "Shipment",
	# 									"customer_reference" => "Shipment",
	# 									"from" => {
	# 										'name' => "Shipment",
	# 										'lines' => ["Shipment"],
	# 										'suburb' => "Shipment",
	# 										'postcode' => '3322',
	# 										'state' => "Shipment"
	# 									},
	# 									'to' => {
	# 										'name' => "Shipment",
	# 										'business_name' => "Shipment",
	# 										'lines' => ["Shipment"
	# 										 ],
	# 										'suburb' => "Shipment",
	# 										'state' => "Shipment",
	# 										'postcode' => '5522',
	# 										'phone' => "232533224"
	# 									},
	# 									'items' => {
	# 										'length' => '55',
	# 										'height' => '55',
	# 										'width' => '55',
	# 										'weight' => '55',
	# 										'item_reference' => '55',
	# 										'product_id' => '55',
	# 										'authority_to_leave' => false
	# 									}
	# 							}
		result = RestClient::Request.new({ :method => :post, :url => @apiURL, 'shipments' => queryParams,
			headers: { 'authorization' => @apikey, 'content-type' => 'application/json', 'account-number' => @accountNumber }})
	end
end

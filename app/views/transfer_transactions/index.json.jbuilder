json.array!(@transfer_transactions) do |transfer_transaction|
  json.extract! transfer_transaction, :id, :payment_confirmed, :amount, :paid, :banking_reference
  json.url transfer_transaction_url(transfer_transaction, format: :json)
end

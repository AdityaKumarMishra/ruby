# == Schema Information
#
# Table name: invoices
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  invoice_date              :datetime
#  date_ordered              :datetime
#  date_billed               :datetime
#  date_shipment             :datetime
#  payment_method            :integer
#  total_amount              :decimal(8, 2)
#  gst_total_amount          :decimal(8, 2)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invoice_file_file_name    :string
#  invoice_file_content_type :string
#  invoice_file_file_size    :integer
#  invoice_file_updated_at   :datetime
#  invoice_no                :string
#

class Invoice < ApplicationRecord
  belongs_to :user
  has_one :address, as: :addresable, dependent: :destroy
  has_many :invoice_specs, :dependent => :destroy

  enum payment_method: [ :paypal, :stripe ]

  before_create :initial_conditions
  after_create :ensure_invoice_no

  validates :user, presence: true
  validates :payment_method, presence: true
  validates :total_amount, presence: true
  validates :gst_total_amount, presence: true

  has_attached_file :invoice_file

  validates_attachment_content_type :invoice_file, :content_type => ['application/pdf']

  def to_s
    invoice_no
  end

  def self.purchase user, products, payment
    Invoice.transaction do
      invoice = Invoice.new(
          :user => user,
          :payment_method => payment,
      )
      invoice.save(:validate => false)
      total_amount = 0
      products.each { |product|
        invoice_spec = InvoiceSpec.create!(
            :invoice => invoice,
            :product => product,
            :name       => product.name,
            :cost       => product.cost,
            :type       => product.type,
            :weight     => product.weight,
            :length     => product.length,
            :width      => product.width,
            :height     => product.height,
            :amount    => product.amount,
            :starting_date    => product.starting_date,
            :stopping_date    => product.stopping_date,
            :expiration_date    => product.expiration_date,
            :quantity    => product.quantity,
            :product_type_id    => product.product_type_id
        )
        total_amount += product.cost * product.amount
      }
      invoice.total_amount = total_amount
      invoice.gst_total_amount = invoice.total_amount + (invoice.total_amount / 100 * 10)

      address = user.addresses.last
      invoice.build_address(
        number:       address.number,
        street_name:  address.street_name,
        street_type:  address.street_type,
        subburb:      address.subburb,
        city:         address.city,
        post_code:    address.post_code,
        state:        address.state,
        country:      address.country
      )
      invoice.save!
    end
  end

  private

  def initial_conditions
    self.invoice_date = DateTime.current
    self.date_ordered = DateTime.current
  end

  def ensure_invoice_no
    update_column(:invoice_no, "#{id}/#{I18n.l invoice_date, :format => :invoice}/#{user.id}")
  end

end

class PaypalPurchasesController < ApplicationController
  include PayPal::SDK::REST
  protect_from_forgery except: :execute_payment
  def execute_payment
    payment = Payment.find(params[:paymentId])
    respond_to do |format|
      if payment.execute(payer_id: params[:PayerID])
        #TODO: exception handling

        # non ideal solution, will work for now - will need to be re-written after first release
        @enrolment = Enrolment.find_by_paypal_payment(params[:paymentId])
        @purchase_addon = PurchaseAddon.find_by_paypal_payment(params[:paymentId])


        if( (@enrolment.nil? and @purchase_addon.nil?))
          #TODO: render to a proper error page
          format.html { redirect_to :root }
          format.json do
            render json: { 'Error': 'Payment is not executed' },
                   status: unprocessable_entity
          end
        end

        # do enrolment
        if ! @enrolment.nil?
          if payment.state == "approved"
            @enrolment.paid_at = payment.create_time
            @enrolment.save!
          end
          #TODO: should redirect to purchase confirmation
          format.html { redirect_to "/dashboard/purchase_summary" }
          format.json { render json: payment }
        end
        #do purchase addon
        if ! @purchase_addon.nil?
          if payment.state == "approved"
            @purchase_addon.paid_at = payment.create_time
            @purchase_addon.date_activated = Time.now
            @purchase_addon.paid!
            @purchase_addon.save!
          end
          #TODO: should redirect to purchase confirmation
          format.html { redirect_to "/dashboard/purchase_summary" }
          format.json { render json: payment }
        end
      else
        flash[:notice] = "Error processing payment - contact support@gradready.com.au"
        format.html { redirect_to :root }
        format.json do
          render json: { 'Error': 'Payment is not executed' },
                 status: unprocessable_entity
        end
      end
    end
  end


  def cancel
    @enrolment = Enrolment.find_by(paypal_token: params[:token])
    @enrolment.destroy if @enrolment
    redirect_to :root
  end
end

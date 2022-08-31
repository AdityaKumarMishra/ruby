class ContactController < ApplicationController
  before_action :load_contacts
  before_action :enable_recommender, only: [:index]
  layout 'layouts/public_page'

  def index
    if params["product_line"] == "umat"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif params["product_line"] == "gamsat"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end
    @contact_form = ContactForm.new
    @product_line = params[:product_line]
    @new_update = PublicUpdate.first
  end

  def create_inquire
    @contact_form = ContactForm.new(contact_params)

    respond_to do |format|
      if @contact_form.save
        ContactFormMailer.user_inqury(@contact_form)
        format.html { redirect_to contact_index_path, notice: 'Form has been saved and send to administrator.' }
        format.json { render :index, status: :created, location: contact_index_path }
      else
        format.html { render :index}
        format.json { render json: @contact_form.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  private

  def load_contacts
    @contacts = Contact.published
  end

  def contact_params
    params.require(:contact_form).permit(:email, :phone_number, :subject, :contact_location_id, :message)
  end

  def enable_recommender
    @show_course_recommender = true
  end
end

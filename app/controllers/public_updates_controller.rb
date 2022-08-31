class PublicUpdatesController < ApplicationController

  def new
    @public_update = PublicUpdate.new
  end

  def create
    @public_update = PublicUpdate.new(update_params)
    respond_to do |format|
      if @public_update.save
        format.html { redirect_to contact_path, notice: 'Contact was successfully updated.' }
      else
        format.html { render :new }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def edit
    @public_update = PublicUpdate.find(params[:id])
  end

  def update
    @public_update = PublicUpdate.find(params[:id])
    @public_update.update(update_params)
    respond_to do |format|
      if @public_update.save
        format.html { redirect_to contact_path, notice: 'Contact was successfully updated.' }
      else
        format.html { render :new }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  private
    def update_params
      params.require(:public_update).permit(:contact_number)
    end
end

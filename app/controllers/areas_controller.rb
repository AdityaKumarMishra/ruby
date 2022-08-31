class AreasController < ApplicationController
  respond_to :html

  def create
    @area = Area.new(area_params)
    @area.save
    respond_with(@area)
  end

  def update
    @area.update(area_params)
    respond_with(@area)
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    respond_with(@area)
  end

  private

    def area_params
      params.require(:area).permit(:city)
    end
end

class HighSchoolsController < ApplicationController

  # GET /HighSchools
  # GET /HighSchools.json
  def index
    if params[:term]
      @high_schools = HighSchool.where("high_schools.name LIKE ?", "%#{params[:term]}%")
    else
      @high_schools = HighSchool.all
    end
  end
end

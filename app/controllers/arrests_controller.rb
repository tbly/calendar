class ArrestsController < ApplicationController
  # GET /arrests
  # GET /arrests.json
  def index
    @arrests = Arrest.order('date DESC').page(params[:page]).per(10)
    @arrest_dates = @arrests.map{|a| a.date}.uniq.sort.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @arrests }
    end
  end

  # GET /arrests/1
  # GET /arrests/1.json
  def show
    @arrest = Arrest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @arrest }
    end
  end
end


class ReviewsController < ApplicationController

  def index
    render json: Review.all
  end

  def show
    render json: Review.find(params[:id])
  end
end

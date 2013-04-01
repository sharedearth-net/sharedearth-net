class FeedbacksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_request
  

  def new
    @item  = @request.item
    @feedback = Feedback.new(:feedback => Feedback::FEEDBACK_POSITIVE)
    
  end

  def create
    @feedback =  @request.feedbacks.build(params[:feedback])    
    @feedback.person_id = current_user.person.id


    item = @feedback.item_request.item
    item.rating = params[:rating]
    item.set_rating
    item.save

    if @feedback.save
      redirect_to dashboard_path
    else
      render :action => 'new'
    end
  end
  
  protected
  
  def get_request
    @request = ItemRequest.find_by_id(params[:request_id])
    redirect_to dashboard_path unless @request
  end
end

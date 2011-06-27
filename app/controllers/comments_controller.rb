class CommentsController < ApplicationController
 def create
  model_name = params[:comment][:commentable_type]
  record_commentable = model_name.constantize.find(params[:comment][:commentable_id])
  record_commentable.comments.create(:commentable => record_commentable, :user_id => current_user.id, :comment => params[:comment][:comment] )
  case model_name
    when "ItemRequest"
      redirect_to request_path(record_commentable)
    when "Item"
      redirect_to item_path(record_commentable)
    when "EventLog"
      redirect_to dashboard_path
    else
     #  
  end
 end
end

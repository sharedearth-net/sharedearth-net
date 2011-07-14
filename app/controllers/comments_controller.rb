class CommentsController < ApplicationController
 def create
  model_name = params[:comment][:commentable_type]
  record_commentable = model_name.constantize.find(params[:comment][:commentable_id])
  @comment = record_commentable.comments.create(:commentable => record_commentable, :user_id => current_user.id, :comment => params[:comment][:comment] )
  
  respond_to do |format|
      format.html { redirection_rules(model_name) }
      format.json do
        @comment_html = render_to_string( :partial => 'comments/comment.html.erb', :locals => {:c => @comment } )
        render :json => { :success => true, :comment_html => @comment_html  }
      end
  end
 end
 
 private
 def redirection_rules(model_name)
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

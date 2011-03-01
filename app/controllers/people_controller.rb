class PeopleController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_person
  before_filter :only_if_person_is_signed_in!, :only => [:edit, :update]

  def show
    @items = @person.items

    if @person.belongs_to? current_user
      @unanswered_requests = @person.unanswered_requests
    else
      @unanswered_requests = @person.unanswered_requests(current_user.person)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def get_person
    @person = Person.find(params[:id])
  end
  
  def only_if_person_is_signed_in!
    redirect_to(root_path, :alert => I18n.t('messages.you_cannot_edit_others')) and return unless @person.belongs_to? current_user
  end
end

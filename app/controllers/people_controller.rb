class PeopleController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_person, :except => [:index]
  before_filter :only_if_person_is_signed_in!, :only => [:edit, :update]
  
  def index
    if params[:search]
      @people = Person.search(params[:search])
    else
      @people = current_user.person.trusted_friends
    end
    respond_to do |format|
      format.html { render :action => 'search' if params[:search] }
      format.xml  { render :xml => @people }
    end
  end

  def show
    if @person.belongs_to? current_user
      @items = @person.items.without_deleted
      @unanswered_requests = @person.unanswered_requests
    else
      @items = @person.items.without_deleted.visible_to_other_users
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

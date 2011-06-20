class PeopleController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_person, :except => [:index]
  before_filter :only_if_person_is_signed_in!, :only => [:edit, :update]
  before_filter :only_own_network!, :only => [:my_network]

  def index
  
    @people = current_user.person.trusted_friends
    
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
  
  def network
    @other, @mutual_friends, @trusted_network, @extended_network = [], [], [], []
    current_person = current_user.person
    unless params[:type].nil?
      case params[:type]
          when 'mutual'
            @mutual_friends = @person.mutural_friends(current_user.person) 
          when 'extended'
            #
          when 'other'
            mutual_friends = @person.mutural_friends(current_user.person)
            trusted_network = @person.trusted_friends
            @other = trusted_network - mutual_friends
            @other.delete_at(@other.index(current_person) || @other.length) unless @person.belongs_to? current_user
          else
            #
      end
    else       
      @trusted_network = @person.trusted_friends
      @mutual_friends = @person.mutural_friends(current_user.person)
      @other = @trusted_network - @mutual_friends
      @other.delete_at(@other.index(current_person) || @other.length) unless @person.belongs_to? current_user
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end
  
  def my_network
    unless params[:type].nil?
      case params[:type]
          when 'trusted'
            @items = @person.trusted_friends_items
          else
            #
      end
    else           
      @items = @person.trusted_friends_items
    end
    @events = EventDisplay.paginate(:page => params[:page], :per_page => 10, :conditions => [ 'person_id=?', current_user.person.id ], 
                                                                             :order => 'created_at DESC', :include => [:event_log])
  end

  def edit
  end

  def update
    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person }
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
  
  def only_own_network!
    redirect_to(root_path, :alert => I18n.t('messages.people.only_own_network')) and return unless @person.belongs_to? current_user
  end
end

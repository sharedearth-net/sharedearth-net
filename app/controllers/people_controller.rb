class PeopleController < ApplicationController
  before_filter :authenticate_user!, :except => :confirm_email_changing
  before_filter :get_person, :except => [:index, :confirm_email_changing]
  before_filter :only_if_person_is_signed_in!, :only => [:edit, :update]
  before_filter :only_own_network!, :only => [:my_network]

  def confirm_email_changing
    @person = Person.find(params[:id])
    if @person.verify_email_change!(params[:code])
      session[:user_id] || @person.user.first.id
      redirect_to edit_person_path(@person), :notice => "Email changed successfully."
    else
      redirect_to :root, :warning => "Something wrong happen during chaning email."
    end
  end

  def index
    @people = current_user.person.trusted_friends

    respond_to do |format|
      format.html { render :action => 'search' if params[:search] }
      format.xml  { render :xml => @people }
    end
  end

  def show
    if @person.belongs_to? current_user
      if params[:filter_type].nil?
        @items = @person.items.without_deleted.sort_by{|i| i.item_type.downcase}
      else
        @items = @person.items.without_deleted.with_type(params[:filter_type])
      end
      @unanswered_requests = @person.unanswered_requests
    else
      if params[:filter_type].nil?
        @items = @person.items.without_deleted.visible_to_other_users.without_hidden.sort_by{|i| i.item_type.downcase}
      else
        @items = @person.items.without_deleted.visible_to_other_users.without_hidden.with_type(params[:filter_type])
      end
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
    @self = ( current_person.id == @person.id )
    unless params[:type].nil?
      case params[:type]
          when 'mutual'
            @mutual_friends = @person.mutural_friends(current_user.person)
          when 'extended'
            #
          when 'other'
            mutual_friends = @person.mutural_friends(current_user.person)
            trusted_network = @person.trusted_friends
            facebook_friends = @person.facebook_friends
            @other = facebook_friends + trusted_network - mutual_friends
            @other.delete_at(@other.index(current_person) || @other.length) unless @person.belongs_to? current_user
          else
            #
      end
    else
      @trusted_network = @person.trusted_friends
      @mutual_friends = @person.mutural_friends(current_user.person)
      facebook_friends = @person.facebook_friends
      @other = facebook_friends + @trusted_network - @mutual_friends
      @other.delete_at(@other.index(current_person) || @other.length) unless @person.belongs_to? current_user
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # Filter view network items and activity based on entity type, action is deprecated will be removed

  def my_network
    case params[:type]
      when 'trusted'
        @items = @person.trusted_friends_items(params[:filter_type]).sort_by{|i| i.item_type.downcase}
        @events = current_user.trusted_network_activity.page(params[:page]).per(25)
      else
        @items = @person.personal_network_items(params[:filter_type]).sort_by{|i| i.item_type.downcase}
        @events = current_user.network_activity.page(params[:page]).per(25)
    end
  end

  def edit
  end

  def update
    redirect_path = @person.has_reviewed_profile? ? person_path(@person) : root_path
    @person.update_attributes(:has_reviewed_profile => true)

    respond_to do |format|
      email_changed = @person.email != params[:person][:email] if params[:person]
      if @person.update_attributes(params[:person])
        format.html do
          if @person.waiting_for_new_email_confirmation?
            redirect_to edit_person_path(@person), :notice => "We sent you email on new address to confirm changes"
          else
            redirect_to redirect_path
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def cancel
    redirect_path = @person.has_reviewed_profile? ? person_path(@person) : root_path
    @person.update_attributes(:has_reviewed_profile => true)
    redirect_to redirect_path
  end

  private

  def get_person
    @person = Person.find_by_id(params[:id])
    if @person.nil? || (current_user.person != @person && @person.authorised_account == false)
      redirect_to dashboard_path
    end
  end

  def only_if_person_is_signed_in!
    redirect_to(root_path, :alert => I18n.t('messages.you_cannot_edit_others')) and return unless current_user.person == @person
  end

  def only_own_network!
    redirect_to(root_path, :alert => I18n.t('messages.people.only_own_network')) and return unless current_user.person == @person
  end
end

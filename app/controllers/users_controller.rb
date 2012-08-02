class UsersController < ApplicationController
  before_filter :check_pending_actions, :except => :confirm
  def new
    @user = User.new
    render :layout => request.xhr? ? "lightbox" : "welcome"
  end

  def please_activate_email
    @user = current_user
    render :layout => "application"
  end

  def resent_activation
    @user = User.find(params[:id])
    redirect_to :root and return unless current_user == @user
    @user.send_confirmation_email
    redirect_to please_activate_email_user_path(@user)
  end

  def create
    @user = User.new({:classic_sing_up => true}.merge(params[:user] || {}))
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, :notice => I18n.t('messages.people.thank_you_check_email')
    else
      render :new
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.verified_email?
      redirect_to :root, :alert => I18n.t('messages.people.email_already_verified')
    elsif params[:code] != @user.email_confirmation_code
      redirect_to :root, :alert => I18n.t('messages.people.confirm_code_incorrect')
    else
      @user.verify_email!(params[:code])
      session[:user_id] = @user.id
      redirect_to :root, :notice => "Email vefiried"
    end
  end
end

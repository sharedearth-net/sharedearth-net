class UsersController < ApplicationController
  def new
    @user = User.new
    render :layout => "welcome"
  end

  def please_activate_email
    @user = User.find(params[:id])
  end

  def resent_activation
    @user = User.find(params[:id])
    @user.send_confirmation_email
    redirect_to please_activate_email_user_path(@user)
  end

  def create
    @user = User.new({:classic_sing_up => true}.merge(params[:user] || {}))
    if @user.save
      #session[:user_id] = @user.id
      redirect_to please_activate_email_user_path(@user), :notice => "Thank you. Check emeil for confirmation letter."
    else
      render :new
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.verified_email?
      redirect_to :root, :alert => "Email already verified"
    elsif params[:code] != @user.email_confirmation_code
      redirect_to :root, :alert => "Confirmation code is not correct"
    else
      @user.verify_email!(params[:code])
      session[:user_id] = @user.id
      redirect_to :root, :notice => "Email vefiried"
    end
  end
end

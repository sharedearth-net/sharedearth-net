class UsersController < ApplicationController
  def new
    @user = User.new
    render :layout => "welcome"
  end

  def create
    @user = User.new({:classic_sing_up => true}.merge(params[:user] || {}))
    if @user.save
      session[:user_id] = @user.id
      redirect_to :root, :notice => "Thank you. Check emeil for confirmation letter."
    else
      render :new
    end
  end

  def confirm
    @user = User.find(params[:id])
    if @user.verified_email?
      redirect_to :root, :warning => "Email already verified"
    elsif params[:code] == @user.email_confirmation_code
      redirect_to :root, :warning => "Confirmation code is not correct"
    else
      @user.verify_email!(params[:code])
      redirect_to :root, :notice => "Email vefiried"
    end
  end
end

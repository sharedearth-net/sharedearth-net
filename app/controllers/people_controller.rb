class PeopleController < ApplicationController
  before_filter :authenticate_user!

  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def edit
  end

  def update
  end
end

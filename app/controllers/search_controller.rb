class SearchController < ApplicationController
  before_filter :authenticate_user!
  def index
    @people, @items = [],[]
    unless params[:search].nil? || params[:search].empty?
      case params[:type]
        when 'items'
          @items  = Item.search(params[:search])
        when 'people'
          @people = Person.search(params[:search])
        when 'all'
          @items = Item.search(params[:search])
          @people = Person.search(params[:search])
        else
          @items = Item.search(params[:search])
          @people = Person.search(params[:search]) if @items.empty?
          if !@items.empty?
            params[:type] = 'items'
          elsif !@people.empty?
            params[:type] = 'people'
          else
            params[:type] = 'all'
          end
      end 
      @people = @people - [current_user.person]
    else
      params[:type] = 'all'
    end
  end

end

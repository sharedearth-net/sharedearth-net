class SearchController < ApplicationController
  def index
  
    unless params[:search].nil? || params[:search].empty?
      case params[:type]
        when 'items'
          @items  = Item.search(params[:search], current_user.person.id)
          @people = []
        when 'people'
          @people = Person.search(params[:search])
          @items  = []
        when 'all'
          @items = Item.search(params[:search], current_user.person.id)
          @people = Person.search(params[:search])
        else
          @items = Item.search(params[:search], current_user.person.id)
          @people = []
          @people = Person.search(params[:search]) if @items.empty?
          if !@items.empty?
            params[:type] = 'items'
          elsif !@people.empty?
            params[:type] = 'people'
          else
            params[:type] = 'all'
          end
      end 
    else
      @items  = []
      @people = []
      params[:type] = 'all'
    end
  end

end

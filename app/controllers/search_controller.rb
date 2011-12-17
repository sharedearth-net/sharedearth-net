class SearchController < ApplicationController
  before_filter :authenticate_user!
  def index
    @people, @items = [],[]
    unless params[:search].nil? || params[:search].empty?
      case params[:type]
        when 'items'
          @items  = Item.search(params[:search], current_person.id)
          @item_in_groups = group_items_by_network(@items)
        when 'people'
          @people = Person.search(params[:search], current_person)
          @people_in_groups = group_people_by_network(@people)
        when 'all'
          @items = Item.search(params[:search], current_person.id)
          @people = Person.search(params[:search], current_person)
          @item_in_groups = group_items_by_network(@items)
          @people_in_groups = group_people_by_network(@people)
        else
          @items = Item.search(params[:search], current_person.id)
          @people = Person.search(params[:search], current_person) if @items.empty?
          @item_in_groups = group_items_by_network(@items)
          @people_in_groups = group_people_by_network(@people)
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
  
  private
  
  def group_items_by_network(items)
		@current_person_id = current_person.id
		@trusted_people_ids = current_person.people_networks.trusted_personal_network.select("trusted_person_id").collect { |r| r.trusted_person_id }.to_set
		@mutual_people_ids = current_person.people_networks.mutual_network.select("trusted_person_id").collect { |r| r.trusted_person_id }.to_set
		
		groups = { :trusted => [], :mutual => [], :other => [] }
		
		items.each do |item|
			if item.owner_id == @current_person_id
				groups[:self] << item
			elsif @trusted_people_ids.include?(item.owner_id)
				groups[:trusted] << item
			elsif @trusted_people_ids.include?(item.owner_id)
				groups[:mutual] << item
			else
				groups[:other] << item
			end
		end
		
		groups[:trusted].sort! { |a, b| a.name <=> b.name }
		groups[:mutual].sort! { |a, b| a.name <=> b.name }
		groups[:other].sort! { |a, b| a.name <=> b.name }

		groups

  end
  
  def group_people_by_network(people)
		@trusted_people_ids = current_person.people_networks.trusted_personal_network.select("trusted_person_id").collect { |r| r.trusted_person_id }.to_set
		@mutual_people_ids = current_person.people_networks.mutual_network.select("trusted_person_id").collect { |r| r.trusted_person_id }.to_set

		groups = { :trusted => [], :mutual => [], :other => [] }

		people.each do |person|
			if @trusted_people_ids.include?(person.id)
				groups[:trusted] << person
			elsif @trusted_people_ids.include?(person.id)
				groups[:mutual] << person
			else
				groups[:other] << person
			end
		end
		
		groups[:trusted].sort! { |a, b| a.name <=> b.name }
		groups[:mutual].sort! { |a, b| a.name <=> b.name }
		groups[:other].sort! { |a, b| a.name <=> b.name }

		groups
  end

end

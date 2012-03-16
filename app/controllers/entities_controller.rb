class EntitiesController < ApplicationController
  before_filter :get_instances

  def grow
    @villages = Village.all
  end

	protected

  def index
    @entities = Entity.all
  end

  def show
  end

  def new
  end

  def create
    variable = instance_variable_get("@#{controller_name.singularize}")
    respond_to do |format|
        if variable.save
          variable.add_admin!(current_person)
          variable.add_items!(current_person)
          format.html { redirect_to(findtheothers_path) }
          format.xml  { render :xml => variable, :status => :created, :location => variable }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => variable.errors, :status => :unprocessable_entity }
        end
      end
  end

  def edit
  end

	def update
    variable = instance_variable_get("@#{controller_name.singularize}")
    respond_to do |format|
      if variable.update_attributes(params[@model_sym])
        format.html { redirect_to variable }
        format.xml  { head :ok }
      else

        format.html { render :action => "edit" }
        format.xml  { render :xml => variable.errors, :status => :unprocessable_entity }
      end
    end
	end

  def destroy
    variable = instance_variable_get("@#{controller_name.singularize}")
    variable.destroy
    redirect_to :controller => controller_name, :action => "index"
  end

  def join
    variable = instance_variable_get("@#{controller_name.singularize}")
    variable.join!(current_person)
    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => "",
                          :activity_html => "" }
      end
    end

  end

  def leave
    variable = instance_variable_get("@#{controller_name.singularize}")
    variable.leave!(current_person)
    respond_to do |format|
      format.html { redirect_to_back }
      format.json do
        render :json => { :success => true,
                          :request_html  => "",
                          :activity_html => "" }
      end
    end
  end

  def get_instances
    @model_name = controller_name.classify.constantize
    @model_sym = controller_name.singularize.to_sym
  end

  def find_entity
    model_name = controller_name.classify.constantize
    model_sym = controller_name.singularize.to_sym
  	@entity = model_name.find_by_id(params[:id])

  end

end

class VillagesController < EntitiesController
  before_filter :authenticate_user!
  before_filter :find_entity, :only => [:show, :edit, :update, :destroy, :leave, :join]
  def index
    @villages = Village.all
  end

  def show
    super
  end

  def new
    @village = Village.new
  end

  def create
    @village = Village.new(params[:village])
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  def join
    super
  end

  def leave
    super
  end

  private

  def find_entity
    @village = Village.find_by_id(params[:id])
  end
end

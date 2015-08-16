class RoomsController < ApplicationController
  PER_PAGE = 5

  before_action :require_authentication, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_room, only: [:show]
  before_action :set_users_room, only: [:edit, :update, :destroy]

  def index
    @search_query = params[:q]
    # O método #map, de coleções, retornará um novo Array contendo o resultado do bloco.
    # Dessa forma, para cada quarto, retornaremos o presenter equivalente.
    rooms = Room.search(@search_query).most_recent.paginate(page: params[:page], per_page: PER_PAGE)
    @rooms = RoomCollectionPresenter.new(rooms, self)
  end

  def show
    if user_signed_in?
      @user_review = @room.reviews.find_or_initialize_by(user_id: current_user.id)
    end
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to @room, notice: t('flash.notice.room_created')
    else
      render action: :new
    end
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: t('flash.notice.room_updated')
    else
      render action: :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      room_model = Room.friendly.find_by(id: params[:id])
      @room = RoomPresenter.new(room_model, self)
    end

    def set_users_room
      @room = current_user.rooms.friendly.find_by(id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:title, :location, :description, :picture)
    end
end

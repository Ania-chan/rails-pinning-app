class PinsController < ApplicationController
  before_action :require_login, except: [:index, :show, :show_by_name]

  def index
    @pins = Pin.all
  end
  
  def show
    @pin = Pin.find(params[:id])
    @users = @pin.users
  end

  def show_by_name
    @pin = Pin.find_by_slug(params[:slug])
    @users = @pin.users
    render :show
  end
  
  def new
    @pin = Pin.new
  end

  def create
    @pin = Pin.new(pin_params)
    if @pin.valid?
      @pin.save
      redirect_to pin_path(@pin.id)
    else
      @errors = @pin.errors
      render :new
    end
  end

  def edit
    @pin = Pin.find_by_id(params[:id])
    render :edit
  end

  def edit_by_name
    @pin = Pin.find_by_slug(params[:slug])
    render :edit
  end

  def update
    @pin = Pin.find(params[:id])
    @pin.update(pin_params)
    if @pin.valid?
      @pin.save
      redirect_to pin_path(@pin.id)
    else
      @errors = @pin.errors
      render :edit
    end
  end

  # def destroy
  #   @pin = Pin.find(params[:id])
  #   @pin.destroy
  #   respond_to do |format|
  #     format.html { redirect_to pins_url, notice: 'Pin was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  def repin
    @pin = Pin.find(params[:id])
    @pin.pinnings.create(user: current_user)
    redirect_to user_path(current_user)
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
  end

end
module Admin
  class CarsController < AdminController
    def index
      @cars = Car.all
    end

    def show
      @car = Car.find(params[:id])
    end

    def edit
      @car = Car.find(params[:id])
      all_select_options
    end

    def new
      all_select_options
    end

    def update
      @car = Car.find(params[:id])
      if @car.update(car_params)
        redirect_to admin_car_path(@car)
      else
        render 'edit'
      end
    end

    def create
      @car = Car.new(car_params)
      if @car.save
        redirect_to admin_car_path(@car)
      else
        render 'new'
      end
    end

    def destroy
      @car = Car.find(params[:id])
      @car.destroy
      redirect_to admin_cars_path
    end

    private

    def car_params
      params.require(:car).permit(:name, :price, :year, :kilometers, :description, images: [])
    end

    def all_select_options
      @car = Car.new
      @categories = Category.all.order(:name)
      @makes = Make.all.order(:name)
      @emission_stickers = EmissionSticker.all.order(:name)
      @conditions = Car.conditions.sort_by { |key, _| key.to_s }.to_h
      @fuels = Car.fuels.sort_by { |key, _| key.to_s }.to_h
      @transmissions = Car.transmissions.sort_by { |key, _| key.to_s }.to_h
      @gearboxes = Car.gearboxes.sort_by { |key, _| key.to_s }.to_h
    end
  end
end

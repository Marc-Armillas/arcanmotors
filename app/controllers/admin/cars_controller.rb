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
    end

    def new
      @car = Car.new
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
  end
end

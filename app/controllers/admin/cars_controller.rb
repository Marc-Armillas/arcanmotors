module Admin
  class CarsController < AdminController
    def index
      @cars = Car.all
    end

    def show
      @car = Car.find(params[:id])
    end

    def edit
      all_select_options

      @car = Car.find(params[:id])
    end

    def new
      all_select_options
    end

    def update
      @car = Car.find(params[:id])

      if car_params[:images].present?
        @car.images.attach(car_params[:images])
      end
      binding.pry
      if @car.update(car_params.except(:images))
        redirect_to admin_car_path(@car), notice: 'El coche se actualizó correctamente.'
      else
        render "edit"
      end
    end

    def create
      @car = Car.new(car_params)
      if @car.save
        redirect_to admin_car_path(@car)
      else
        render "new"
      end
    end

    def destroy
      @car = Car.find(params[:id])
      @car.destroy
      redirect_to admin_cars_path
    end

    def remove_image
      @car = Car.find(params[:id])
      image = @car.images.find(params[:image_id])  # Busca la imagen por el ID
      image.purge  # Elimina la imagen
      redirect_to edit_admin_car_path(@car), notice: 'Imagen eliminada con éxito.'
    end

    private

    def car_params
      params.require(:car).permit(
        :category_id, :make_id, :emission_sticker_id, :condition, :first_registration, :transmission, :fuel, :model,
        :cubic_capacity, :power, :previous_owners, :origin_country_id,:model_description, :name, :price, :year, :kilometers,
        :description, :in_home_page, :next_inspection, :exterior_color, :manufacturer_color_name, :doors, :seats,
        :interior_color, :interior_material, :vin, :consumption_city, :consumption_suburban, :consumption_highway,
        :consumption_combined, :base_price, :tax, :total_price, images: []
      ).tap do |p|
        p[:condition] = p[:condition].to_i if p[:condition].present?
        p[:gearbox] = p[:gearbox].to_i if p[:gearbox].present?
        p[:transmission] = p[:transmission].to_i if p[:transmission].present?
        p[:fuel] = p[:fuel].to_i if p[:fuel].present?
      end
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

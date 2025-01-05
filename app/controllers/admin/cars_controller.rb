module Admin
  class CarsController < AdminController
    def index
      @cars = Car.all
    end

    def show
      @car = Car.find(get_car_id)
      render template: "cars/show"
    end

    def edit
      all_select_options
      default_form_field_values

      @car = Car.find(get_car_id)
    end

    def new
      all_select_options
      default_form_field_values
    end

    def update
      @car = Car.find(get_car_id)

      if car_params[:images].present?
        @car.images.attach(car_params[:images])
      end

      if @car.update(car_params.except(:images))
        message = "El coche se actualizó correctamente."
        message += " Se ha ocultado de la página de inicio y de la web ya que el coche está vendido." if @car.sold?
        redirect_to admin_car_path(@car), notice: message
      else
        render "edit"
      end
    end

    def create
      @car = Car.new(car_params)
      if @car.save
        flash[:success] = "Coche creado correctamente."
        redirect_to admin_car_path(@car)
      else
        flash[:error] = "Error al crear el coche."
        redirect_to new_admin_car_path(car_params)
      end
    end

    def destroy
      @car = Car.find(get_car_id)
      @car.destroy

      redirect_to admin_cars_path
    end

    def remove_image
      @car = Car.find(get_car_id)
      image = @car.images.find(params[:image_id])
      image.purge  # Elimina la imagen

      redirect_to edit_admin_car_path(@car), notice: "Imagen eliminada con éxito."
    end

    private

    def car_params
      params.require(:car).permit(
        :category_id, :make_id, :emission_sticker_id, :condition, :first_registration, :transmission, :gearbox, :fuel, :model,
        :cubic_capacity, :power, :previous_owners, :origin_country_id,:model_description, :name, :price, :year, :kilometers,
        :description, :in_home_page, :is_public, :status, :next_inspection, :exterior_color, :manufacturer_color_name, :doors, :seats,
        :interior_color, :interior_material, :vin, :consumption_city, :consumption_suburban, :consumption_highway,
        :consumption_combined, :base_price, :tax, :total_price, images: []
      ).tap do |p|
        p[:condition] = p[:condition].to_i if p[:condition].present?
        p[:gearbox] = p[:gearbox].to_i if p[:gearbox].present?
        p[:transmission] = p[:transmission].to_i if p[:transmission].present?
        p[:fuel] = p[:fuel].to_i if p[:fuel].present?
        p[:status] = p[:status].to_i if p[:status].present?
        p[:vin] = p[:vin].presence
      end
    end

    def all_select_options
      @car = Car.new
      @categories = Category.all.order(:name)
      @makes = Make.all.order(:name)
      @emission_stickers = EmissionSticker.all.order(:name)
      @countries = Country.all.order(:name)

      fuels_desired_order = %w[petrol diesel electric hybrid_petrol hybrid_diesel other]
      @fuels = Car.fuels.sort_by { |key, _| fuels_desired_order.index(key.to_s) || fuels_desired_order.size }
      @conditions = Car.conditions.sort_by { |key, _| key.to_s }.reverse.to_h
      @transmissions = Car.transmissions.sort_by { |key, _| key.to_s }.to_h
      @gearboxes = Car.gearboxes.sort_by { |key, _| key.to_s }.to_h
      @statuses = Car.statuses.sort_by { |key, _| key.to_s }.to_h
    end

    def default_form_field_values
      @default_make_id = Make.find_by(name: "Porsche").id
      @default_origin_country_id = Country.find_by(name: "Spain").id
      @default_category_id = Category.find_by(name: "SUV").id
    end
  end
end
# {"on_sale"=>0, "reserved"=>2, "sold"=>1}
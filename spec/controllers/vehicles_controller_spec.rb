require "rails_helper"

RSpec.describe VehiclesController, type: :controller do
  login_admin_as_current_user

  # This should return the minimal set of attributes required to create a valid
  # Vehicle. As you add validations to Vehicle, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { 
    # Nothing is required, but add a name to avoid a ParameterMissing error
    attributes_for(:vehicle, :name => "Vehicle 1")
  }

  let(:invalid_attributes) { 
    # Nothing is required, but VIN length must be <= 17
    attributes_for(:vehicle, :vin => "123456789012345678") 
  }

  describe "GET #index" do
    it "redirects to the current user's provider" do
      get :index, {}
      expect(response).to redirect_to(@current_user.current_provider)
    end
  end

  describe "GET #show" do
    it "assigns the requested vehicle as @vehicle" do
      vehicle = create(:vehicle, :provider => @current_user.current_provider)
      get :show, {:id => vehicle.to_param}
      expect(assigns(:vehicle)).to eq(vehicle)
    end
  end

  describe "GET #new" do
    it "assigns a new vehicle as @vehicle" do
      get :new, {}
      expect(assigns(:vehicle)).to be_a_new(Vehicle)
    end
  end

  describe "GET #edit" do
    it "assigns the requested vehicle as @vehicle" do
      vehicle = create(:vehicle, :provider => @current_user.current_provider)
      get :edit, {:id => vehicle.to_param}
      expect(assigns(:vehicle)).to eq(vehicle)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Vehicle" do
        expect {
          post :create, {:vehicle => valid_attributes}
        }.to change(Vehicle, :count).by(1)
      end

      it "assigns a newly created vehicle as @vehicle" do
        post :create, {:vehicle => valid_attributes}
        expect(assigns(:vehicle)).to be_a(Vehicle)
        expect(assigns(:vehicle)).to be_persisted
      end

      it "redirects to the current user's provider" do
        post :create, {:vehicle => valid_attributes}
        expect(response).to redirect_to(@current_user.current_provider)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved vehicle as @vehicle" do
        post :create, {:vehicle => invalid_attributes}
        expect(assigns(:vehicle)).to be_a_new(Vehicle)
      end

      it "re-renders the 'new' template" do
        post :create, {:vehicle => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          :name => "Name",
          :default_driver_id => 1,
          :year => 2000,
          :make => "Make",
          :model => "Model",
          :license_plate => "License Plate",
          :vin => "12345678901234567",
          :garaged_location => "Garaged Location",
          :active => false,
          :reportable => false
        }
      }

      it "updates the requested vehicle" do
        vehicle = create(:vehicle, :provider => @current_user.current_provider)
        expect {
          put :update, {:id => vehicle.to_param, :vehicle => new_attributes}
        }.to change { vehicle.reload.garaged_location }.from(nil).to("Garaged Location")
      end

      it "assigns the requested vehicle as @vehicle" do
        vehicle = create(:vehicle, :provider => @current_user.current_provider)
        put :update, {:id => vehicle.to_param, :vehicle => new_attributes}
        expect(assigns(:vehicle)).to eq(vehicle)
      end

      it "redirects to the current user's provider" do
        vehicle = create(:vehicle, :provider => @current_user.current_provider)
        put :update, {:id => vehicle.to_param, :vehicle => new_attributes}
        expect(response).to redirect_to(@current_user.current_provider)
      end
    end

    context "with invalid params" do
      it "assigns the vehicle as @vehicle" do
        vehicle = create(:vehicle, :provider => @current_user.current_provider)
        put :update, {:id => vehicle.to_param, :vehicle => invalid_attributes}
        expect(assigns(:vehicle)).to eq(vehicle)
      end

      it "re-renders the 'edit' template" do
        vehicle = create(:vehicle, :provider => @current_user.current_provider)
        put :update, {:id => vehicle.to_param, :vehicle => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested vehicle" do
      vehicle = create(:vehicle, :provider => @current_user.current_provider)
      expect {
        delete :destroy, {:id => vehicle.to_param}
      }.to change(Vehicle, :count).by(-1)
    end

    it "redirects to the current user's provider" do
      vehicle = create(:vehicle, :provider => @current_user.current_provider)
      delete :destroy, {:id => vehicle.to_param}
      expect(response).to redirect_to(@current_user.current_provider)
    end
  end

end

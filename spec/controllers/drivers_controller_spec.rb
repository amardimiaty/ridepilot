require "rails_helper"

RSpec.describe DriversController, type: :controller do
  login_admin_as_current_user
  
  # This should return the minimal set of attributes required to create a valid
  # Driver. As you add validations to Driver, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:driver)
  }

  let(:invalid_attributes) {
    attributes_for(:driver, :name => "")
  }

  describe "GET #index" do
    it "redirects to the current provider" do
      get :index, {}
      expect(response).to redirect_to(@current_user.current_provider)
    end
  end

  describe "GET #new" do
    it "assigns a new driver as @driver" do
      get :new, {}
      expect(assigns(:driver)).to be_a_new(Driver)
    end
  end

  describe "GET #edit" do
    it "assigns the requested driver as @driver" do
      driver = create(:driver, :provider => @current_user.current_provider)
      get :edit, {:id => driver.to_param}
      expect(assigns(:driver)).to eq(driver)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Driver" do
        expect {
          post :create, {:driver => valid_attributes}
        }.to change(Driver, :count).by(1)
      end

      it "assigns a newly created driver as @driver" do
        post :create, {:driver => valid_attributes}
        expect(assigns(:driver)).to be_a(Driver)
        expect(assigns(:driver)).to be_persisted
      end

      it "redirects to the current provider" do
        post :create, {:driver => valid_attributes}
        expect(response).to redirect_to(@current_user.current_provider)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved driver as @driver" do
        post :create, {:driver => invalid_attributes}
        expect(assigns(:driver)).to be_a_new(Driver)
      end

      it "re-renders the 'new' template" do
        post :create, {:driver => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          :active => false,
          :paid => false,
          :name => "Judy",
          :user => create(:user, :current_provider => @current_user.current_provider).id,
        }
      }

      it "updates the requested driver" do
        driver = create(:driver, :provider => @current_user.current_provider, :name => "Bob")
        expect {
          put :update, {:id => driver.to_param, :driver => new_attributes}
        }.to change { driver.reload.name }.from("Bob").to("Judy")
      end

      it "assigns the requested driver as @driver" do
        driver = create(:driver, :provider => @current_user.current_provider)
        put :update, {:id => driver.to_param, :driver => valid_attributes}
        expect(assigns(:driver)).to eq(driver)
      end

      it "redirects to the current provider" do
        driver = create(:driver, :provider => @current_user.current_provider)
        put :update, {:id => driver.to_param, :driver => valid_attributes}
        expect(response).to redirect_to(@current_user.current_provider)
      end
    end

    context "with invalid params" do
      it "assigns the driver as @driver" do
        driver = create(:driver, :provider => @current_user.current_provider)
        put :update, {:id => driver.to_param, :driver => invalid_attributes}
        expect(assigns(:driver)).to eq(driver)
      end

      it "re-renders the 'edit' template" do
        driver = create(:driver, :provider => @current_user.current_provider)
        put :update, {:id => driver.to_param, :driver => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested driver" do
      driver = create(:driver, :provider => @current_user.current_provider)
      expect {
        delete :destroy, {:id => driver.to_param}
      }.to change(Driver, :count).by(-1)
    end

    it "redirects to the current provider" do
      driver = create(:driver, :provider => @current_user.current_provider)
      delete :destroy, {:id => driver.to_param}
      expect(response).to redirect_to(@current_user.current_provider)
    end
  end

end

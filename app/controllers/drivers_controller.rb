class DriversController < ApplicationController
  load_and_authorize_resource

  def index
    redirect_to provider_path(current_provider)
  end

  def new
    @driver.provider = current_provider
    prep_edit
  end

  def edit
    prep_edit
  end

  def update
    if @driver.update_attributes(driver_params)
      flash[:notice] = "Driver updated"
      redirect_to provider_path(current_provider)
    else
      prep_edit
      render :action=>:edit
    end
  end

  def create
    @driver.provider = current_provider
    if @driver.save
      flash[:notice] = "Driver created"
      redirect_to provider_path(current_provider)
    else
      prep_edit
      render :action=>:new
    end
  end

  def destroy
    @driver.destroy
    redirect_to provider_path(current_provider)
  end

  private
  
  def prep_edit
    @available_users = @driver.provider.users - User.drivers(@driver.provider)
    @available_users << @driver.user if @driver.user
  end
  
  def driver_params
    params.require(:driver).permit(:active, :paid, :name, :user_id)
  end
end

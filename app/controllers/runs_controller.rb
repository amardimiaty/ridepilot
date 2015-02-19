# a note on general run workflow:
# Runs are created as part of the trip scheduling 
# process; they're associated with a vehicle and
# a driver.  At the end of the day, the driver
# must update the run with post-run data like
# odometer start/end and no-shows.  That is 
# presented by my_runs and end_of_day

class RunsController < ApplicationController
  load_and_authorize_resource
  before_filter :filter_runs, :only => :index

  def index
    @runs = @runs.for_provider(current_provider_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trips }
      format.js {
        rows = if @runs.present?
          @runs.map do |r|
            render_to_string :partial => "row.html", :locals => { :run => r }
          end 
        else 
          [render_to_string( :partial => "no_runs.html" )]
        end

        render :json => { :rows => rows }
      }
    end
  end

  def new
    @run = Run.new
    @run.provider_id = current_provider_id
    @drivers = Driver.where(:provider_id=>@run.provider_id)
    @vehicles = Vehicle.active.where(:provider_id=>@run.provider_id)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  def uncompleted_runs
    @runs = Run.for_provider(current_provider_id).where("complete = false").order("date desc")
    render "index"
  end

  def edit
    @drivers      = Driver.where(:provider_id=>@run.provider_id)
    @vehicles     = Vehicle.active.where(:provider_id=>@run.provider_id)
    @trip_results = TRIP_RESULT_CODES.map { |k,v| [v,k] }
  end

  def create
    run_params = params[:run]
    authorize! :manage, current_provider
    run_params[:provider_id] = current_provider_id

    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html { redirect_to(runs_path(date_range(@run)), :notice => 'Run was successfully created.') }
        format.xml  { render :xml => @run, :status => :created, :location => @run }
      else
        @drivers = Driver.where(:provider_id=>@run.provider_id)
        @vehicles = Vehicle.active.where(:provider_id=>@run.provider_id)

        format.html { render :action => "new" }
        format.xml  { render :xml => @run.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    run_params = params[:run]
    authorize! :manage, current_provider
    run_params[:provider_id] = current_provider_id
    
    # Massage trip_attributes. We're not using a nested form so that we can use the partial for
    # AJAX requests, and as a result we need to reset the keys in the trips_attributes hash and
    # add the trip id. If there's a Rails-way to do this, I couldn't find it.
    corrected_trip_attributes = {}
    params[:trips_attributes].each do |key, values|
      corrected_trip_attributes[corrected_trip_attributes.size.to_s] = values.merge({"id" => key})
    end
    run_params[:trips_attributes] = corrected_trip_attributes
    
    respond_to do |format|
      if @run.update_attributes(run_params)
        format.html { redirect_to(runs_path(date_range(@run)), :notice => 'Run was successfully updated.') }
        format.xml  { head :ok }
      else
        @drivers = Driver.where(:provider_id=>@run.provider_id)
        @vehicles = Vehicle.active.where(:provider_id=>@run.provider_id)
        @trip_results = TRIP_RESULT_CODES.map { |k,v| [v,k] }
        
        format.html { render :action => "edit" }
        format.xml  { render :xml => @run.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @run.destroy

    respond_to do |format|
      format.html { redirect_to(runs_path(date_range(@run)), :notice => 'Run was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  def for_date
    date = Date.parse params[:date]
    @runs = @runs.for_provider(current_provider_id).incomplete_on date
    cab_run = Run.new :cab => true
    cab_run.id = -1
    @runs = @runs + [cab_run] 
    render :json =>  @runs.to_json 
  end
  
  private
  
  def filter_runs
    if params[:end].present? && params[:start].present?
      @week_start = Time.at params[:start].to_i
      @week_end   = Time.at params[:end].to_i
    else
      time     = Time.now
      @week_start = time.beginning_of_week
      @week_end   = @week_start + 6.days
    end
    
    @runs = @runs.
      where("date >= '#{@week_start.to_s(:db)}'").
      where("date < '#{@week_end.to_s(:db)}'")
  end

  def date_range(run)
    if run.date
      week_start = run.date.beginning_of_week
      {:start => week_start.to_time.to_i, :end => (week_start + 6.days).to_time.to_i } 
    end    
  end
end

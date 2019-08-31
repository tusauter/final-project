require "json"
require "open-uri"

class ApartmentsController < ApplicationController
  
  def index
    @is_signed_in = self.signed_in
    @account_activated = false
    if @is_signed_in
      if User.where({ :id => session[:user_id] }).first.account_activated == true
        @account_activated = true
      end
    end
    
    locations_this_year = CurrentLocation.where({ :year => 2019 }).pluck(:apartment_id)
    @apartments = Apartment.where({ :id => locations_this_year })
    
    respond_to do |format|
      format.json {
        if @is_signed_in == false
          render({ :plain => ({ :status => "not signed in" }).to_json })
        else
          json_apartments = @apartments.map {|x| display_json(x) }
          render({ :plain => json_apartments.to_json })
        end
      }
      format.html {
        if @is_signed_in == false
          add_flash :danger, "You must be signed in to view specifics on apartments in the system."
        end
        if @account_activated == false
          add_flash :danger, "You need to activate your account to see contact information for specific apartments."
        end
        render({ :template => 'apartments/index' })
      }
    end
    
  end
  
  def show
    @is_signed_in = self.signed_in
    @the_apartment = Apartment.where({ :id => params[:apartment_id] })
    
    if @the_apartment.count == 0
      add_flash :warning, "Huh... we couldn't find this apartment. Maybe try again?"
      redirect_to("/")
      return
    end
    
    @the_apartment = @the_apartment[0]
    
    the_location = CurrentLocation.where({ :apartment_id => @the_apartment.id, :year => 2019 })
    
    @the_price = nil
    @the_owner = nil
    if the_location.count > 0
      @the_price = the_location[0].price
      @the_owner = User.where({ :id => the_location[0].user_id }).first
    end
    
    lat = @the_apartment.latitude
    lng = @the_apartment.longitude
    @static_map_link = "https://maps.googleapis.com/maps/api/staticmap?center=#{lat},#{lng}&zoom=14&size=800x150&key=#{ENV["GOOGLE_MAPS_KEY"]}&markers=#{lat},#{lng}&scale=2"
    
    respond_to do |format|
      format.json {
        if @is_signed_in
          render({ :plain => self.to_json })
        else
          render({ :plain => ({ :status => "not signed in." }).to_json })
        end
        return
      }
      format.html {
        if @is_signed_in == false
          add_flash :danger, "You must be signed in to view specifics on apartments in the system."
          redirect_to("/sign_in")
          return
        end
        if User.where({ :id => session[:user_id] }).first.account_activated == false
          add_flash :warning, "You must activate your account to view specifics on apartments in the system."
          redirect_to("/")
          return
        end
        render({ :template => "apartments/show" })
      }
    end
    
  end
  
  def create
    is_signed_in = self.signed_in
    if is_signed_in == false
      add_flash :danger, "Uh oh, you need to be signed in!"
      redirect_to("/")
      return
    end

    apartment_check = CurrentLocation.where({ :user_id => session[:user_id], :year => 2019 }).count

    if apartment_check > 0
      add_flash :danger, "It looks like you've already got an apartment in the system."
      redirect_to("/users/#{session[:user_id]}")
      return
    end

    google_maps_api_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" +
        params[:qs_address] + ", " + params[:qs_city] + " " + params[:qs_state] + "&key=" + ENV["GOOGLE_MAPS_KEY"]
    raw_maps_results = open(google_maps_api_url).read
    json_maps_results = JSON.parse(raw_maps_results)

    the_country = json_maps_results["results"][0].fetch("address_components").select{|x| x["types"].include? "country"}[0].fetch("long_name")
    # add new apartment
    the_apartment = Apartment.new({ :address => json_maps_results.fetch("formatted_address", params[:qs_address]),
                                    :apartment_number => params[:qs_apt_num],
                                    :city => params[:qs_city],
                                    :state => params[:qs_state],
                                    :zip => params[:qs_zip],
                                    :latitude => params[:qs_lat],
                                    :longitude => params[:qs_lng],
                                    :country => the_country
                                  })

    apartment_saved = the_apartment.save

    if apartment_saved
      # add new current location record
      user_location = CurrentLocation.new({
                                              :user_id => session[:user_id],
                                              :year => 2019,
                                              :apartment_id => the_apartment.id
                                          })
      if user_location.save
        add_flash :success, "Thanks for adding some info on your apartment!"
        redirect_to("/users/#{session[:user_id]}")
        return
      else
        the_apartment.destroy
      end
    end

    add_flash :danger, "Uh oh, we couldn't save your apartment. Please try again."
    redirect_to("/users/#{session[:user_id]}")
  end
  
  def display_json(the_apartment)
    for_display = {
      :id => the_apartment[:id] == nil ? the_apartment["id"] : the_apartment[:id],
      :address  => the_apartment[:address] == nil ? the_apartment["address"] : the_apartment[:address],
      :city => the_apartment[:city] == nil ? the_apartment["city"] : the_apartment[:city],
      :state => the_apartment[:state] == nil ? the_apartment["state"] : the_apartment[:state],
      :country => the_apartment[:country] == nil ? the_apartment["country"] : the_apartment[:country],
      :gps_coordinates => {
        :longitude => the_apartment[:longitude] == nil ? the_apartment["longitude"] : the_apartment[:longitude],
        :latitude => the_apartment[:latitude] == nil ? the_apartment["latitude"] : the_apartment[:latitude]
        }
    }
    if session[:user_id] != nil && User.where({ :id => session[:user_id] }).first.account_activated == true
      occupant_info = CurrentLocation.where({ :apartment_id => the_apartment.id, :year => 2019 })
      if occupant_info.count > 0
        the_occupant = User.where({ :id => occupant_info[0][:user_id] })
        if the_occupant.count > 0
          for_display[:contact_name] = the_occupant[0].first_name.strip + " " + the_occupant[0].last_name.strip
          for_display[:contact_email] = the_occupant[0].email
        end
      end
    end
    return for_display
  end


end
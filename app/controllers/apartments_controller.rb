require "json"
require "open-uri"

class ApartmentsController < ApplicationController

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

end
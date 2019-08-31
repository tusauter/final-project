# == Schema Information
#
# Table name: apartments
#
#  id                   :integer          not null, primary key
#  address              :text             not null
#  apartment_number     :text
#  city                 :text             not null
#  state                :text             not null
#  zip                  :text             not null
#  country              :text
#  longitude            :float            not null
#  latitude             :float            not null
#  square_feet          :integer
#  total_rooms          :integer
#  in_unit_washer_dryer :boolean
#  building_has_laundry :boolean
#  floor_of_building    :integer
#  building_has_gym     :boolean
#  building_has_pool    :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  soft_deleted_at      :datetime
#
# Indexes
#
#  apartments_address_apartment_number_city_state_key  (address,apartment_number,city,state)
#

class Apartment < ApplicationRecord
  
  def to_radians(the_number)
    return the_number * Math::PI / 180.0;
  end
  
  def distance_to(point_lat, point_lng)
    rad = 6371000.0
    phi1 = self.to_radians(self.latitude)
    phi2 = self.to_radians(point_lat)
    delta_phi = self.to_radians(point_lat - self.latitude)
    delta_lambda = self.to_radians(point_lng - self.longitude)
    a = Math.sin(delta_phi / 2) * Math.sin(delta_phi / 2) +
      Math.cos(phi1) * Math.cos(phi2) * Math.sin(delta_lambda / 2) * Math.sin(delta_lambda / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    return rad * c * 0.000621371192
  end
  
end

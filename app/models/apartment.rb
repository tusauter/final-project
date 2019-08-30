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
#  apartments_address_apartment_number_city_state_key  (address,apartment_number,city,state) UNIQUE
#

class Apartment < ApplicationRecord
end

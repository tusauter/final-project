# == Schema Information
#
# Table name: current_locations
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  year            :integer          not null
#  apartment_id    :integer
#  price           :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  soft_deleted_at :datetime
#
# Indexes
#
#  current_locations_apartment_idx  (apartment_id)
#  current_locations_user_idx       (user_id)
#

class CurrentLocation < ApplicationRecord
end

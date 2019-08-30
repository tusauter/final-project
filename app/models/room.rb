# == Schema Information
#
# Table name: rooms
#
#  id                :integer          not null, primary key
#  apartment_id      :integer          not null
#  has_own_bathroom  :boolean
#  has_walkin_closet :boolean
#  room_square_feet  :integer
#  asking_price      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  soft_deleted_at   :datetime
#
# Indexes
#
#  rooms_apartment_idx  (apartment_id)
#

class Room < ApplicationRecord
end

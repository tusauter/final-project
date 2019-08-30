# == Schema Information
#
# Table name: room_statuses
#
#  id                   :integer          not null, primary key
#  room_id              :integer          not null
#  year                 :integer          not null
#  owner_id             :integer          not null
#  gender_preference    :text
#  available_for_sublet :boolean
#  sublettor_id         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  soft_deleted_at      :datetime
#
# Indexes
#
#  room_statuses_owner_idx      (owner_id)
#  room_statuses_room_idx       (room_id)
#  room_statuses_sublettor_idx  (sublettor_id)
#

class RoomStatus < ApplicationRecord
end

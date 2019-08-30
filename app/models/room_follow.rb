# == Schema Information
#
# Table name: room_follows
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  room_id         :integer          not null
#  year            :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  soft_deleted_at :datetime
#
# Indexes
#
#  room_follows_room_idx  (room_id)
#  room_follows_user_idx  (user_id)
#

class RoomFollow < ApplicationRecord
end

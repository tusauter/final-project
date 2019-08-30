# == Schema Information
#
# Table name: user_statuses
#
#  id                          :integer          not null, primary key
#  user_id                     :integer          not null
#  year                        :integer          not null
#  destination                 :text
#  found_sublettor             :boolean
#  found_room_near_destination :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  soft_deleted_at             :datetime
#
# Indexes
#
#  user_statuses_user_idx  (user_id)
#

class UserStatus < ApplicationRecord
end

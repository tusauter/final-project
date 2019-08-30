# == Schema Information
#
# Table name: destinations
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  year            :integer          not null
#  city            :text
#  state           :text
#  country         :text
#  longitude       :float
#  latitude        :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  soft_deleted_at :datetime
#
# Indexes
#
#  destinations_user_idx  (user_id)
#

class Destination < ApplicationRecord
end

# == Schema Information
#
# Table name: apartment_follows
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  apartment_id    :integer          not null
#  year            :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  soft_deleted_at :datetime
#
# Indexes
#
#  apartment_follows_apartment_idx  (apartment_id)
#  apartment_follows_user_idx       (user_id)
#

class ApartmentFollow < ApplicationRecord
end

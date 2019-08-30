# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  email                 :text             not null
#  first_name            :text             not null
#  last_name             :text             not null
#  gender                :text
#  salt                  :text             not null
#  password_hash         :text             not null
#  activation_token      :text
#  activation_expiry     :datetime
#  account_activated     :boolean          default(FALSE), not null
#  password_reset_token  :text
#  password_reset_expiry :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  soft_deleted_at       :datetime
#

class User < ApplicationRecord
  require 'digest/md5'

  def self.current_users
    begin
      users = ActiveRecord::Base.connection.execute(
          "SELECT u.id, u.first_name, u.last_name, u.email, u.gender,
                  CASE
                       WHEN a.city IS NULL THEN 'not provided'
                       ELSE a.city
                  END AS current_city,
                  CASE
                      WHEN d.city IS NULL THEN 'not provided'
                      ELSE d.city
                  END AS destination_city
           FROM users u
                LEFT JOIN destinations d ON u.id = d.user_id
                LEFT JOIN current_locations cl ON u.id = cl.user_id
                LEFT JOIN apartments a ON cl.apartment_id = a.id
           WHERE (d.year IS NULL OR d.year = #{Date.today.year}) AND
                 (cl.year IS NULL OR cl.year = #{Date.today.year}) AND
                 u.soft_deleted_at IS NULL
           ORDER BY u.id;"
      )
      return users.map {|x| {
          :user_id => x["id"],
          :name => x["first_name"] + " " + x["last_name"],
          :email => x["email"],
          :gender => x["gender"],
          :current_city => x["current_city"],
          :destination_city => x["destination_city"]
        }
      }
    rescue
      return []
    end
  end

  def has_apartment(the_year)
    the_query = "SELECT *
                 FROM users u
                      INNER JOIN current_locations cl ON u.id = cl.user_id
                 WHERE u.id = #{self.id} AND
                       year = #{the_year};"
    the_apartment = ActiveRecord::Base.connection.execute(the_query)
    if the_apartment.count == 0
      return false
    else
      return true
    end
  end

  def current_apartment(the_year)
    the_query = "SELECT a.apartment_id
                 FROM users u
                      LEFT JOIN current_locations cl ON u.id = cl.user_id
                      LEFT JOIN apartments a ON cl.apartment_id = a.apartment_id
                 WHERE u.user_id = #{self.id} AND
                       year = #{the_year};"
    the_apartment = ActiveRecord::Base.connection.execute(the_query)
    if the_apartment.count == 0
      return nil
    else
      return Apartment.where({ :apartment_id => the_apartment[0]["apartment_id"] }).first
    end
  end

  def destination(the_year)
    return Destination.where("user_id = #{self.id} AND year = #{the_year}").first
  end

  def gravatar_link
    hashed_email = Digest::MD5.hexdigest(self.email)
    return "https://gravatar.com/avatar/#{hashed_email}?s=200"
  end

end

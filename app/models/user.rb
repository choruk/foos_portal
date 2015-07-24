class User < ActiveRecord::Base
  validates_presence_of :slack_user_id, :slack_user_name
end

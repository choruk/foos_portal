class User < ActiveRecord::Base
  has_many :results

  validates_presence_of :slack_user_id, :slack_user_name
end

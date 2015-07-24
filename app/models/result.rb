class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates_presence_of :user, :game
  validates_inclusion_of :win, in: [true, false]
end

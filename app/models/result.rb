class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  scope :wins, -> { where(win: true) }
  scope :finished, -> { joins(:games).where(Game.finished_sql('games')) }

  validates_presence_of :user, :game
  validates_inclusion_of :win, in: [true, false]
end

class Game < ActiveRecord::Base
  has_many :results

  validates_inclusion_of :abandoned, in: [true, false]
  validates_presence_of :started_at, if: -> { finished_at.present? }
end

class Game < ActiveRecord::Base
  has_many :results

  validates_inclusion_of :abandoned, in: [true, false]

  def started_at
    created_at
  end
end

class Game < ActiveRecord::Base
  validates_inclusion_of :abandoned, in: [true, false]

  def started_at
    created_at
  end
end

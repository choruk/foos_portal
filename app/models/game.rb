class Game < ActiveRecord::Base
  PLAYERS_NEEDED_TO_PLAY = 4
  PLAYERS_NEEDED_TO_WIN = 2

  has_many :results, dependent: :destroy
  has_many :users, through: :results

  scope :in_progress, -> { where('finished_at IS NULL AND abandoned = false AND started_at IS NOT NULL') }
  scope :in_setup, -> { where(started_at: nil, abandoned: false) }
  scope :finished, -> { where(finished_sql) }

  def self.finished_sql(table_name = '')
    table_name += '.' if table_name.present?
    "#{table_name}finished_at IS NOT NULL AND #{table_name}abandoned = false"
  end

  validates_inclusion_of :abandoned, in: [true, false]
  validates_presence_of :started_at, if: -> { finished_at.present? }

  def in_progress?
    started_at.present? && !abandoned && finished_at.nil?
  end

  def in_setup?
    started_at.nil? && !abandoned
  end

  def finished?
    number_of_winners == PLAYERS_NEEDED_TO_WIN
  end

  def players
    results.map(&:user)
  end

  def players_needed_to_start
    PLAYERS_NEEDED_TO_PLAY - players.size
  end

  def players_needed_to_finish
    PLAYERS_NEEDED_TO_WIN - number_of_winners
  end

  def all_players_quit?
    results.size == 0
  end

  def win_recorded?
    number_of_winners > 0
  end

  def winning_team
    results.select(&:win).map(&:user)
  end

  def losing_team
    results.reject(&:win).map(&:user)
  end

  def suggested_matchup
    unless players.all?(&:is_ranked?)
      random_players = players.shuffle
      matchup = [first_team(random_players), second_team(random_players)].join(' vs. ')
      return "randomized matchup (not all players yet ranked!): #{matchup}"
    end

    sorted = players.sort_by(&:rank).reverse

    matchup = [first_team(sorted),second_team(sorted)].join(' vs. ')
    "suggested matchup: #{matchup}"
  end

  private

  def first_team(sorted_players)
    team_mentions([sorted_players[0],sorted_players[3]])
  end

  def second_team(sorted_players)
    team_mentions([sorted_players[1],sorted_players[2]])
  end

  def team_mentions(team)
    team.map(&:mention_and_rank).join(' and ')
  end

  def number_of_winners
    results.where(win: true).length
  end
end

# == Schema Information
#
# Table name: game_states
#
#  id              :integer          not null, primary key
#  state           :integer
#  jam_number      :integer
#  period_number   :integer
#  home_id         :integer
#  away_id         :integer
#  game_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  jam_clock_id    :integer
#  period_clock_id :integer
#  timeout         :integer
#

class GameState < ActiveRecord::Base
  belongs_to :game
  belongs_to :home, class_name: "TeamState"
  belongs_to :away, class_name: "TeamState"
  belongs_to :jam_clock, class_name: "ClockState"
  belongs_to :period_clock, class_name: "ClockState"

  accepts_nested_attributes_for :home, :away, :period_clock, :jam_clock

  enum state: %i[pregame halftime jam lineup timeout unofficial_final final]
  enum timeout: %i[official_timeout home_team_timeout home_team_official_review away_team_timeout away_team_official_review]

  def self.demo!
    o = self.demo
    o.save
    o
  end

  def self.demo
    self.new ({
      state: :pregame,
      jam_number: 0,
      period_number: 0,
      jam_clock_attributes: {
        time: 90*60,
        offset: 0,
        display: "90:00"
      },
      period_clock_attributes: {
        time: 0,
        offset: 0,
        display: "00"
      },
      home_attributes: {
        name: "Atlanta Rollergirls",
        initials: "ARG",
        color: "#2082a6",
        text_color: "#ffffff",
        logo: "/assets/team_logos/Atlanta.png",
        points: 0,
        jam_points: 0,
        is_taking_official_review: false,
        is_taking_timeout: false,
        has_official_review: true,
        timeouts: 3,
        jammer_attributes: {
          is_lead: false,
          name: "Nattie Long Legs",
          number: "504"
        }
      },
      away_attributes: {
        name: "Gotham Rollergirls",
        initials: "GRG",
        color: "#f50031",
        text_color: "#ffffff",
        logo: "/assets/team_logos/Gotham.png",
        points: 0,
        jam_points: 0,
        is_taking_official_review: false,
        is_taking_timeout: false,
        has_official_review: true,
        timeouts: 3,
        jammer_attributes: {
          is_lead: true,
          name: "Bonnie Thunders",
          number: "340"
        }
      }
    })
  end

  def jam_clock_label
    state.to_s.humanize.upcase
  end

  def as_json
    super(include: {
        :home => {include: :jammer},
        :away => {include: :jammer},
        :jam_clock => {},
        :period_clock => {},
        :game => {}
      })
  end

  def to_json(options = {})
    hash = self.as_json
    JSON.pretty_generate(hash, options)
  end

  private

  def init_teams
    self.build_home if self.home.nil?
    self.build_away if self.away.nil?
  end
  after_initialize :init_teams
end

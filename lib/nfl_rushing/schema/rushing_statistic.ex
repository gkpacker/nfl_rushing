defmodule NflRushing.Schema.RushingStatistic do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          player_name: String.t(),
          team: String.t(),
          player_position: String.t(),
          attempts: pos_integer(),
          attempts_per_game_average: float(),
          total_yards: integer(),
          average_yards_per_attempt: float(),
          yards_per_game: float(),
          total_touchdowns: pos_integer(),
          longest_rush: integer(),
          longest_rush_was_touchdown?: boolean(),
          first_downs: pos_integer(),
          first_down_percentage: float(),
          above_twenty_yards: pos_integer(),
          above_forty_yards: pos_integer(),
          fumbles: pos_integer()
        }

  @fields ~w(
    player_name
    team
    player_position
    attempts
    attempts_per_game_average
    total_yards
    average_yards_per_attempt
    yards_per_game
    total_touchdowns
    longest_rush
    longest_rush_was_touchdown?
    first_downs
    first_down_percentage
    above_twenty_yards
    above_forty_yards
    fumbles
  )a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rushing_statistics" do
    field :player_name, :string
    field :team, :string
    field :player_position, :string
    field :attempts, :integer
    field :attempts_per_game_average, :float
    field :total_yards, :integer
    field :average_yards_per_attempt, :float
    field :yards_per_game, :float
    field :total_touchdowns, :integer
    field :longest_rush, :integer
    field :longest_rush_was_touchdown?, :boolean, default: false
    field :first_downs, :integer
    field :first_down_percentage, :float
    field :above_twenty_yards, :integer
    field :above_forty_yards, :integer
    field :fumbles, :integer

    timestamps()
  end

  @doc false
  def changeset(rushing, attrs) do
    rushing
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end

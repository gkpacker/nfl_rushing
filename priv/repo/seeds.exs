# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NflRushing.Repo.insert!(%NflRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias NflRushing.Repo
alias NflRushing.RushingStatisticTranslator

require Logger

rushing_statistics =
  "priv/repo/rushing.json"
  |> File.read!()
  |> Jason.decode!()

for rushing_statistic <- rushing_statistics do
  Logger.info("Seeding rushing statistic #{inspect(rushing_statistic)}")

  rushing_statistic
  |> RushingStatisticTranslator.from_string_map()
  |> Repo.insert!()
end

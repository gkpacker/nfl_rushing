defmodule NflRushingWeb.RushingStatisticsController do
  use NflRushingWeb, :controller

  def export_csv(conn, params) do
    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="report.csv"])
      |> send_chunked(:ok)

    options = %{
      filter: %{player_name: params["player_name"]},
      sort_options: %{
        sort_by: params["sort_by"],
        sort_order: params["sort_order"]
      }
    }

    {:ok, conn} = NflRushingWeb.export_csv(options, &chunk_data(&1, conn))

    conn
  end

  defp chunk_data(stream, conn) do
    Enum.reduce_while(stream, conn, fn data, conn ->
      case chunk(conn, data) do
        {:ok, conn} ->
          {:cont, conn}

        {:error, :closed} ->
          {:halt, conn}
      end
    end)
  end
end

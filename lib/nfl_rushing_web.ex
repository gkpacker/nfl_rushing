defmodule NflRushingWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use NflRushingWeb, :controller
      use NflRushingWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def list_rushing_statistics(options \\ []) do
    domain_options = domain_options(options)

    NflRushing.list_rushing_statistics(domain_options)
  end

  def export_csv(options, callback) do
    domain_options = domain_options(options)

    NflRushing.export_csv(domain_options, callback)
  end

  defp domain_options(options) do
    sort_by =
      options
      |> get_in([:sort, :sort_by])
      |> sort_by()

    sort_order =
      options
      |> get_in([:sort, :sort_order])
      |> sort_order()

    Keyword.put(options, :sort, %{sort_by: sort_by, sort_order: sort_order})
  end

  defp sort_by("Yds"), do: :total_yards
  defp sort_by("Td"), do: :total_touchdowns
  defp sort_by("Lng"), do: :longest_rush
  defp sort_by(_), do: :inserted_at

  defp sort_order("asc"), do: :asc
  defp sort_order("desc"), do: :desc
  defp sort_order(_), do: :desc

  def controller do
    quote do
      use Phoenix.Controller, namespace: NflRushingWeb

      import Plug.Conn
      import NflRushingWeb.Gettext
      alias NflRushingWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/nfl_rushing_web/templates",
        namespace: NflRushingWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {NflRushingWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import NflRushingWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import NflRushingWeb.ErrorHelpers
      import NflRushingWeb.Gettext
      alias NflRushingWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

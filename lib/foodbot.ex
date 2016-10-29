defmodule Foodbot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    config = Application.get_env(:foodbot, :endpoint)
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Foodbot.Router, [], config),
      supervisor(Foodbot.Restaurant.Supervisor, []),
    ]

    opts = [strategy: :one_for_one, name: Foodbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

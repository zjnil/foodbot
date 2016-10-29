defmodule Foodbot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    port = Config.get_integer(:foodbot, :port)
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Foodbot.Router, [], [port: port]),
      supervisor(Foodbot.Restaurant.Supervisor, []),
    ]

    opts = [strategy: :one_for_one, name: Foodbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Foodbot do
  use Application
  alias Plug.Adapters.Cowboy

  def start(_type, _args) do
    port = Config.get_integer(:foodbot, :port)
    children = [
      Cowboy.child_spec(:http, Foodbot.Router, [], [port: port]),
      restaurant_pool_supervisor([]),
    ]

    opts = [strategy: :one_for_one, name: Foodbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def restaurant_pool_supervisor(args) do
    config = [
      name: {:local, Foodbot.Restaurant.WorkerPool},
      worker_module: Foodbot.Restaurant.Worker,
      size: 8,
      max_overflow: 8
    ]

    :poolboy.child_spec(Foodbot.Restaurant.WorkerPool, config, args)
  end
end

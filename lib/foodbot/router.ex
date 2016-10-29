defmodule Foodbot.Router do
  use Plug.Router
  alias Foodbot.Slack

  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch


  post "/" do
    resp = Slack.command(conn.params["text"])
    json = Poison.encode!(resp)
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, json)
  end

  match _ do
    send_resp(conn, 404, "")
  end
end

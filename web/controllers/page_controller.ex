defmodule Pepe.PageController do
  use Pepe.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

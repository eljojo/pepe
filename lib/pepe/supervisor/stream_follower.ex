defmodule Pepe.Supervisor.StreamFollower do
  use Supervisor

  alias Pepe.User
  alias Pepe.Repo
  alias Pepe.StreamFollower

  def start_link() do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(client_name) do
    # This is probably a huge hack
    children = Enum.map(Repo.all(User), fn user ->
      function = fn -> StreamFollower.stream(user) end
      worker(Task, [function])
    end)
    supervise(children, strategy: :one_for_one)
  end
end

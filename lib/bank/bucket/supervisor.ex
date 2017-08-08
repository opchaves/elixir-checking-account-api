defmodule Bank.Bucket.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Bank.Bucket.Registry, name: Bank.Bucket.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule BankWeb.Plugs.SetBuckets do
  alias Bank.Bucket.Registry

  def init(_params) do
    res = Registry.create(Registry, "operations")
    :ok
  end

  def call(conn, _params) do
    conn
  end
end

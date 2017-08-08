defmodule Bank.Bucket.Bucket do
  use Agent

  @doc """
  Starts a new bucket.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Get a value from the `bucket` by `key`
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `bucket
  """
  def put(bucket, key, value) do
    operations = Agent.get(bucket, &Map.get(&1, key))

    operations = 
      case operations do
        nil -> [value]
        _ -> operations ++ [value]
      end
      
    Agent.update(bucket, &Map.put(&1, key, operations))
  end
end

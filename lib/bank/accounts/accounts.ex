defmodule Bank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bank.Bucket.{Bucket, Registry}
  alias Bank.Accounts.Operation

  def get_operations_by_account(number) do
    {:ok, bucket} = Registry.lookup(Registry, "operations")
    case Bucket.get(bucket, number) do
      nil -> []
      operations -> operations
    end
  end

  @doc """
  Creates an operation.
  """
  def create_operation(number, attrs \\ %Operation{}) do
    {:ok, bucket} = Registry.lookup(Registry, "operations")
    Bucket.put(bucket, number, attrs)
  end
end

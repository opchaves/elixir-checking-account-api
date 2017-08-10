defmodule Bank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bank.Bucket.{Bucket, Registry}
  alias Bank.Accounts.Operation

  @bucket_name "operations"

  def get_operations_by_account(number) do
    {:ok, bucket} = Registry.lookup(Registry, @bucket_name)
    case Bucket.get(bucket, number) do
      nil -> []
      operations -> operations
    end
  end

  @doc """
  Creates an operation.
  """
  def create_operation(number, attrs \\ %Operation{}) do
    {:ok, bucket} = Registry.lookup(Registry, @bucket_name)
    Bucket.put(bucket, number, attrs)
    {:ok, attrs}
  end

  @doc """
  Returns the balance of a given account. The balance is the sum of all
  operations until today. Debit operations are considered negative values
  """
  def get_balance(number) do
    {:ok, bucket} = Registry.lookup(Registry, @bucket_name)

    Bucket.get(bucket, number)
    |> sort_operations_by_date
    |> filter_operations_till_now
    |> Enum.reduce(0, &balance_reduce/2) 
  end

  def balance_reduce(%Operation{amount: amount, type: type}, acc) do
    if Enum.member?(["purchase", "withdrawal", "debits"], type) do
      acc - amount
    else
      acc + amount
    end
  end

  defp filter_operations_till_now(operations) do
    now = NaiveDateTime.utc_now

    operations
    |> Enum.filter(fn op -> 
      NaiveDateTime.compare(op.date, now) == :lt
    end)
  end

  @doc """
  Returns a list of operations sorted by date (ASC)

  ## Examples

      iex> operations = [%{date: ~N[2017-01-01 10:20:19]}, %{date: ~N[2017-01-01 10:20:18]}, %{date: ~N[2017-01-01 10:19:00]}]
      iex> Bank.Accounts.sort_operations_by_date(operations)
      [%{date: ~N[2017-01-01 10:19:00]}, %{date: ~N[2017-01-01 10:20:18]}, %{date: ~N[2017-01-01 10:20:19]}]

  """
  def sort_operations_by_date(operations) do
    operations
    |> Enum.sort(fn(%{date: date1}, %{date: date2}) ->
      NaiveDateTime.compare(date1, date2) == :lt
    end) 
  end
end

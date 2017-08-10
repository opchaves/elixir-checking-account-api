defmodule Bank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Bank.Bucket.{Bucket, Registry}
  alias Bank.Accounts.Operation

  @bucket_name "operations"
  @debit_types ["purchase", "withdrawal", "debits"]
  @credit_types ["deposit", "salary", "credits"]

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
    |> calculate_balance 
  end

  def calculate_balance(operations) do
    operations
    |> Enum.reduce(0, fn(%{type: type, amount: amount}, acc) -> 
      cond do
        Enum.member?(@credit_types, type) -> acc + amount
        Enum.member?(@debit_types, type) -> acc - amount
        true -> acc
      end
    end)
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

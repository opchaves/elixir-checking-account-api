defmodule Bank.Accounts.AccountsTest do
  use ExUnit.Case, async: true

  alias Bank.Bucket.Bucket
  alias Bank.Accounts.Operation

  @operations [
    %Operation{number: "123", amount: "500", description: "some operation", type: "deposit", date: "2017-08-01T00:00:00"},
    %Operation{number: "123", amount: "1000", description: "some operation", type: "deposit", date: "2017-08-02T00:00:00"},
    %Operation{number: "123", amount: "150", description: "some operation", type: "purchase", date: "2017-08-01T00:00:00"},
    %Operation{number: "123", amount: "35", description: "some operation", type: "purchase", date: "2017-08-02T00:00:00"},
    %Operation{number: "123", amount: "220", description: "some operation", type: "withdrawal", date: "2017-08-05T00:00:00"},
    %Operation{number: "123", amount: "390", description: "some operation", type: "withdrawal", date: "2017-08-08T00:00:00"}
  ]

  setup do
    {:ok, bucket} = start_supervised Bucket
    # ExUnit will merge this map into the test context
    %{bucket: bucket}
  end

  # extract the bucket from the test context (is a map) with pattern matching
  test "stores values by key", %{bucket: bucket} do
    assert Bucket.get(bucket, "123") == nil

    Bucket.put(bucket, "123", %Operation{number: "123"})
    assert Bucket.get(bucket, "123") == [%Operation{number: "123"}]
  end

  test "get current balance of a given account", %{bucket: bucket} do
    @operations
    |> Enum.each(&Bucket.put(bucket, "123", &1))
  end
end

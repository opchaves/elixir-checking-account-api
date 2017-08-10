defmodule Bank.Accounts.AccountsTest do
  use ExUnit.Case, async: true
  doctest Bank.Accounts

  alias Bank.Bucket.{Registry}
  alias Bank.Accounts
  alias Bank.Accounts.Operation

  @operations [
    %Operation{number: "123", amount: 500, description: "some operation", type: "deposit", date: ~N[2017-08-01 00:00:00]},
    %Operation{number: "123", amount: 1000, description: "some operation", type: "deposit", date: ~N[2017-08-02 00:00:00]},
    %Operation{number: "123", amount: 150, description: "some operation", type: "purchase", date: ~N[2017-08-01 00:00:00]},
    %Operation{number: "123", amount: 35, description: "some operation", type: "purchase", date: ~N[2017-08-02 00:00:00]},
    %Operation{number: "123", amount: 220, description: "some operation", type: "withdrawal", date: ~N[2017-08-05 00:00:00]},
    %Operation{number: "123", amount: 390, description: "some operation", type: "withdrawal", date: NaiveDateTime.utc_now}
  ]

  setup do
    Registry.stop(Registry)
    start_supervised Registry
    Registry.create(Registry, "operations")
  end

  # extract the bucket from the test context (is a map) with pattern matching
  test "stores an operation an retrieves by account number" do
    assert Accounts.get_operations_by_account("123") == []
  
    assert {:ok, %Operation{} = operation} = Accounts.create_operation("123", List.first(@operations))

    assert Accounts.get_operations_by_account("123") == [operation]
  end

  test "get current balance of a given account" do
    Enum.each(@operations, &Accounts.create_operation("123", &1))
    assert length(Accounts.get_operations_by_account("123")) == 6

    assert Accounts.get_balance("123") == 705
  end
end

defmodule Bank.Accounts.AccountsTest do
  use ExUnit.Case, async: true
  doctest Bank.Accounts

  alias Bank.Utils.DateUtil
  alias Bank.Bucket.{Registry}
  alias Bank.Accounts
  alias Bank.Accounts.Operation

  @account_number "123"
  @today DateUtil.date_time(NaiveDateTime.utc_now, :start)
  @ten_days_ago DateUtil.subtract_days(@today, 10)
  @nine_days_ago DateUtil.subtract_days(@today, 9)
  @eight_days_ago DateUtil.subtract_days(@today, 8)
  @seven_days_ago DateUtil.subtract_days(@today, 7)
  @six_days_ago DateUtil.subtract_days(@today, 6)
  @four_days_ago DateUtil.subtract_days(@today, 4)
  @three_days_ago DateUtil.subtract_days(@today, 3)
  @two_days_ago DateUtil.subtract_days(@today, 2)

  @operations [
    %Operation{number: @account_number, amount: 500, description: "Deposit", type: "deposit", date: @ten_days_ago},
    %Operation{number: @account_number, amount: 150, description: "Amazon", type: "purchase", date: @ten_days_ago},
    %Operation{number: @account_number, amount: 50, description: "Deposit", type: "deposit", date: @nine_days_ago},
    %Operation{number: @account_number, amount: 500, description: "Best Buy", type: "purchase", date: @nine_days_ago},
    %Operation{number: @account_number, amount: 200, description: "Salary", type: "salary", date: @seven_days_ago},
    %Operation{number: @account_number, amount: 80, description: "Withdrawal", type: "withdrawal", date: @six_days_ago},
    %Operation{number: @account_number, amount: 60, description: "Amazon", type: "purchase", date: @four_days_ago},
    %Operation{number: @account_number, amount: 900, description: "Salary", type: "salary", date: @three_days_ago},
    %Operation{number: @account_number, amount: 730, description: "Withdrawal", type: "withdrawal", date: @three_days_ago},
    %Operation{number: @account_number, amount: 250, description: "Forever", type: "purchase", date: @two_days_ago},
  ]

  @dt_ten_days_ago NaiveDateTime.to_date(@ten_days_ago)
  @dt_nine_days_ago NaiveDateTime.to_date(@nine_days_ago)
  @dt_eight_days_ago NaiveDateTime.to_date(@eight_days_ago)
  @dt_seven_days_ago NaiveDateTime.to_date(@seven_days_ago)
  @dt_six_days_ago NaiveDateTime.to_date(@six_days_ago)
  @dt_four_days_ago NaiveDateTime.to_date(@four_days_ago)
  @dt_two_days_ago NaiveDateTime.to_date(@two_days_ago)

  setup do
    # ensure a clean state for each test
    Application.stop :bank
    Application.start :bank
  end

  setup do
    # creates a bucket "operations" a registers it in the GenServer
    Registry.create(Registry, "operations")
  end

  test "stores an operation an retrieves by account number" do
    assert Accounts.get_operations_by_account(@account_number) == []
  
    assert {:ok, %Operation{} = operation} = Accounts.create_operation(@account_number, List.first(@operations))

    assert Accounts.get_operations_by_account(@account_number) == [operation]
  end

  test "get the current balance of a given account" do
    Enum.each(@operations, &Accounts.create_operation(@account_number, &1))
    assert length(Accounts.get_operations_by_account(@account_number)) == 10

    assert Accounts.get_balance(@account_number) == -120
  end

  test "get the bank statement of a period of dates" do
    Enum.each(@operations, &Accounts.create_operation(@account_number, &1))

    assert [
      %{balance: 350, date: @dt_ten_days_ago, operations: [%Operation{}, %Operation{}]}, 
      %{balance: -100, date: @dt_nine_days_ago, operations: [%Operation{}, %Operation{}]}, 
      %{balance: 100, date: @dt_seven_days_ago, operations: [%Operation{}]}, 
      %{balance: 20, date: @dt_six_days_ago, operations: [%Operation{}]}, 
    ] = Accounts.get_statement(@account_number, @ten_days_ago, @six_days_ago)

  end

  test "computes periods of debt" do
    Enum.each(@operations, &Accounts.create_operation(@account_number, &1))

    assert [
      %{principal: -100, start: @dt_nine_days_ago, end: @dt_eight_days_ago},
      %{principal: -40, start: @dt_four_days_ago, end: @dt_four_days_ago},
      %{principal: -120, start: @dt_two_days_ago},
    ] = Accounts.get_periods_of_debt(@account_number)
  end
end

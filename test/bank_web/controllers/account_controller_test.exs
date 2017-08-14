defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  alias Bank.Utils.DateUtil

  @account_number "123"
  @today DateUtil.date_time(NaiveDateTime.utc_now, :start)
  @ten_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 10))
  @nine_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 9))
  @seven_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 7))
  @six_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 6))
  @four_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 4))
  @three_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 3))
  @two_days_ago NaiveDateTime.to_string(DateUtil.subtract_days(@today, 2))

  @operation %{number: @account_number, amount: "500", description: "Deposit", type: "deposit", date: @ten_days_ago}

  @operations [
    %{number: @account_number, amount: "500", description: "Deposit", type: "deposit", date: @ten_days_ago},
    %{number: @account_number, amount: "150", description: "Amazon", type: "purchase", date: @ten_days_ago},
    %{number: @account_number, amount: "50", description: "Deposit", type: "deposit", date: @nine_days_ago},
    %{number: @account_number, amount: "500", description: "Best Buy", type: "purchase", date: @nine_days_ago},
    %{number: @account_number, amount: "200", description: "Salary", type: "salary", date: @seven_days_ago},
    %{number: @account_number, amount: "80", description: "Withdrawal", type: "withdrawal", date: @six_days_ago},
    %{number: @account_number, amount: "60", description: "Amazon", type: "purchase", date: @four_days_ago},
    %{number: @account_number, amount: "900", description: "Salary", type: "salary", date: @three_days_ago},
    %{number: @account_number, amount: "730", description: "Withdrawal", type: "withdrawal", date: @three_days_ago},
    %{number: @account_number, amount: "250", description: "Forever", type: "purchase", date: @two_days_ago},
  ]

  @dt_10_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 10)))
  @dt_9_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 9)))
  @dt_8_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 8)))
  @dt_7_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 7)))
  @dt_6_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 6)))
  @dt_4_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 4)))
  @dt_2_days_ago Date.to_string(NaiveDateTime.to_date(DateUtil.subtract_days(@today, 2)))

  setup do
    # ensure a clean state for each test
    Application.stop :bank
    Application.start :bank
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "list all operations of a given account", %{conn: conn} do
      conn = get conn, account_path(conn, :index, @account_number)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "creates an operation" do
    test "renders operation when data is valid", %{conn: conn} do
      conn = post conn, account_path(conn, :create, @account_number), operation: @operation
      assert %{"number" => @account_number} = json_response(conn, 201)["data"]

      conn = get conn, account_path(conn, :index, @account_number)
      assert json_response(conn, 200)["data"] == [%{
        "number" => @account_number,
        "amount" => 500.0,
        "description" => "Deposit",
        "type" => "deposit",
        "date" => String.replace(@ten_days_ago, " ", "T")
      }]
    end
  end

  describe "get balance" do
    test "renders the balance of a given account", %{conn: conn} do
      Enum.each(@operations, fn operation ->
        post conn, account_path(conn, :create, @account_number), operation: operation
      end)

      conn = get conn, account_path(conn, :balance, @account_number)
      assert json_response(conn, 200)["data"] == %{"balance" => -120}
    end
  end

  describe "get statement" do
    # TODO add another test to handle the case an invalid date is passed in or end_date > start_date
    test "renders the account statement of a period of dates", %{conn: conn} do
      Enum.each(@operations, fn operation ->
        post conn, account_path(conn, :create, @account_number), operation: operation
      end)

      conn = get conn, account_path(conn, :statement, @account_number, @dt_10_days_ago, @dt_6_days_ago)
      assert [
        %{"balance" => 350.0, "date" => @dt_10_days_ago, "operations" => [%{}, %{}]}, 
        %{"balance" => -100.0, "date" => @dt_9_days_ago, "operations" => [%{}, %{}]}, 
        %{"balance" => 100.0, "date" => @dt_7_days_ago, "operations" => [%{}]}, 
        %{"balance" => 20.0, "date" => @dt_6_days_ago, "operations" => [%{}]}, 
      ] = json_response(conn, 200)["data"]
    end
  end

  describe "Compute periods of debt" do
    test "renders the periods in which the account balance was negative", %{conn: conn} do
      Enum.each(@operations, fn operation ->
        post conn, account_path(conn, :create, @account_number), operation: operation
      end) 

      conn = get conn, account_path(conn, :debts, @account_number)
      assert [
        %{"principal" => -100.0, "start" => @dt_9_days_ago, "end" => @dt_8_days_ago},
        %{"principal" => -40.0, "start" => @dt_4_days_ago, "end" => @dt_4_days_ago},
        %{"principal" => -120.0, "start" => @dt_2_days_ago},
      ] = json_response(conn, 200)["data"]
    end
  end
end

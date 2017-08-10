defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  @single_operation %{number: "123", amount: "500", description: "some operation", type: "deposit", date: "2017-08-01T00:00:00"}

  @operations [
    %{number: "123", amount: "1000", description: "some operation", type: "deposit", date: "2017-08-02T00:00:00"},
    %{number: "123", amount: "500", description: "some operation", type: "deposit", date: "2017-08-01T00:00:00"},
    %{number: "123", amount: "150", description: "some operation", type: "purchase", date: "2017-08-01T00:00:00"},
    %{number: "123", amount: "35", description: "some operation", type: "purchase", date: "2017-08-02T00:00:00"},
    %{number: "123", amount: "220", description: "some operation", type: "withdrawal", date: "2017-08-05T00:00:00"},
    %{number: "123", amount: "390", description: "some operation", type: "withdrawal", date: "2017-08-08T00:00:00"}
  ]

  @number "123"

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
      conn = get conn, account_path(conn, :index, @number)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "creates an operation" do
    test "renders operation when data is valid", %{conn: conn} do
      conn = post conn, account_path(conn, :create, @number), operation: @single_operation
      assert %{"number" => number} = json_response(conn, 201)["data"]

      conn = get conn, account_path(conn, :index, number)
      assert json_response(conn, 200)["data"] == [%{
        "number" => number,
        "amount" => 500,
        "description" => "some operation",
        "type" => "deposit",
        "date" => "2017-08-01T00:00:00"
      }]
    end
  end

  describe "get balance" do
    test "renders the balance of a given account", %{conn: conn} do
      Enum.each(@operations, fn operation ->
        post conn, account_path(conn, :create, @number), operation: operation
      end)

      conn = get conn, account_path(conn, :balance, @number)
      assert json_response(conn, 200)["data"] == %{"balance" => 705}
    end
  end

  describe "get statement" do
    # TODO add another test to handle the case an invalid date is passed in or end_date > start_date
    test "renders the account statement of a period of dates", %{conn: conn} do
      Enum.each(@operations, fn operation ->
        post conn, account_path(conn, :create, @number), operation: operation
      end)

      conn = get conn, account_path(conn, :statement, @number, "2017-08-01T00:00:00", "2017-08-02T23:59:59")
      assert [%{
        "date" => "2017-08-01",
        "operations" => [%{}, %{}],
        "balance" => 350.0
      }, %{
        "date" => "2017-08-02",
        "operations" => [%{}, %{}],
        "balance" => 1315.0
      }] = json_response(conn, 200)["data"]
    end
  end
end

defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  @create_attrs %{number: "123", amount: "500.9", description: "some operation", type: "deposit", date: "2017-08-01T00:00:00"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "list all operations of a given account", %{conn: conn} do
      conn = get conn, account_path(conn, :index, "123")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "creates an operation" do
    test "renders operation when data is valid", %{conn: conn} do
      conn = post conn, account_path(conn, :create, "123"), operation: @create_attrs
      assert %{"number" => number} = json_response(conn, 201)["data"]

      conn = get conn, account_path(conn, :index, number)
      assert json_response(conn, 200)["data"] == [%{
        "number" => number,
        "amount" => 500.9,
        "description" => "some operation",
        "type" => "deposit",
        "date" => "2017-08-01T00:00:00"
      }]
    end
  end
end

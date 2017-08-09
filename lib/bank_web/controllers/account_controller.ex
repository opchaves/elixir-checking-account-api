defmodule BankWeb.AccountController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Bank.Accounts.Operation

  action_fallback BankWeb.FallbackController

  def index(conn, %{"number" => number}) do
    operations = Accounts.get_operations_by_account(number)
    render(conn, "index.json", operations: operations)
  end

  def create(conn, %{"number" => number, "operation" => operation}) do
    {amount, _} = Float.parse operation["amount"]

    operation = %Operation{
      number: number,
      type: operation["type"],
      description: operation["description"],
      amount: amount,
      date: NaiveDateTime.from_iso8601!(operation["date"])
    }

    Accounts.create_operation(number, operation)
    render(conn, "show.json", operation: operation)
  end


  def balance(conn, _params) do
    render(conn, "index.json", operations: [%{}])
  end


  def statement(conn, _params) do
    render(conn, "index.json", operations: [%{}])
  end
end

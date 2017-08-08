defmodule BankWeb.AccountController do
  use BankWeb, :controller

  alias Bank.Accounts

  action_fallback BankWeb.FallbackController

  def index(conn, %{"number" => number}) do
    operations = Accounts.get_operations_by_account(number)
    IO.inspect operations
    IO.puts "======================="
    render(conn, "index.json", operations: operations)
  end
end

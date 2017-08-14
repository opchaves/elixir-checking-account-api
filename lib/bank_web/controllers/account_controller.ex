defmodule BankWeb.AccountController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Bank.Accounts.Operation

  action_fallback BankWeb.FallbackController

  def index(conn, %{"number" => number}) do
    operations = Accounts.get_operations_by_account(number)
    render(conn, "index.json", operations: operations)
  end

  @doc """
  First step: Adding operations on a checking account
  """
  def create(conn, %{"number" => number, "operation" => operation}) do
    {amount, _} = Float.parse operation["amount"]

    # TODO validate input

    operation = %Operation{
      number: number,
      type: operation["type"],
      description: operation["description"],
      amount: amount,
      date: NaiveDateTime.from_iso8601!(operation["date"])
    }

    with {:ok, %Operation{} = operation} <- Accounts.create_operation(number, operation) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", account_path(conn, :index, number))
      |> render("show.json", operation: operation)
    end
  end

  @doc """
  Second step: Get the current balance
  """
  def balance(conn, %{"number" => number}) do
    balance = Accounts.get_balance number
    render(conn, "balance.json", balance: balance)
  end

  @doc """
  Third step: Get the bank statement 
  """
  def statement(conn, %{"number" => number, "start_date" => start_date, "end_date" => end_date}) do
    start_date = NaiveDateTime.from_iso8601!(start_date)
    end_date = NaiveDateTime.from_iso8601!(end_date)
    statement = Accounts.get_statement(number, start_date, end_date)
    render(conn, "statement.json", statement: statement)
  end

  @doc """
  Fourth step: Compute periods of debt 
  """
  def debts(conn, %{"number" => number}) do
    period_debts = Accounts.get_periods_of_debt(number)
    render(conn, "debts.json", debts: period_debts)
  end
end

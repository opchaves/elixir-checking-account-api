defmodule BankWeb.AccountView do
  use BankWeb, :view
  alias BankWeb.AccountView

  def render("index.json", %{operations: operations}) do
    %{data: render_many(List.flatten(operations), AccountView, "operation.json")}
  end

  def render("show.json", %{operation: operation}) do
    %{data: render_one(operation, AccountView, "operation.json")}
  end

  def render("balance.json", %{balance: balance}) do
    %{data: %{balance: balance}}
  end

  def render("statement.json", %{statement: statement}) do
    %{data: statement} 
  end

  def render("debts.json", %{debts: debts}) do
    %{data: debts} 
  end

  def render("operation.json", %{account: operation}) do
    %{number: operation.number,
      type: operation.type,
      description: operation.description,
      amount: operation.amount,
      date: operation.date}
  end
end

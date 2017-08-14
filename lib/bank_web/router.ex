defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankWeb do
    pipe_through :api

    get "/accounts/:number/operations", AccountController, :index
    post "/accounts/:number/operations", AccountController, :create
    get "/accounts/:number/balance", AccountController, :balance
    get "/accounts/:number/statement/:start_date/:end_date", AccountController, :statement
    get "/accounts/:number/debts", AccountController, :debts
  end
end

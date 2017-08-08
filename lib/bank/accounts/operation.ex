defmodule Bank.Accounts.Operation do
  @moduledoc """
    It holds the data related to an operation within a struct
  """

  defstruct number: nil, type: nil, description: nil, amount: nil, date: nil
end

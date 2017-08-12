defmodule Bank.Utils.DateUtil do

  @doc """
  Add `days` to `date`

  ## Examples

      iex> Bank.Utils.DateUtil.add_days(~N[2017-01-01 10:20:00], 2)
      ~N[2017-01-03 10:20:00]
  
  """
  def add_days(date, days) do
    NaiveDateTime.add(date, 3600 * 24 * days)    
  end

  @doc """
  Add `minutes` to `date`

  ## Examples

      iex> Bank.Utils.DateUtil.add_minutes(~N[2017-01-01 10:20:00], 2)
      ~N[2017-01-01 10:22:00]
  
  """
  def add_minutes(date, minutes) do
    NaiveDateTime.add(date, 60 * minutes)    
  end

  @doc """
  Subtract `days` from `date`

  ## Examples

      iex> Bank.Utils.DateUtil.subtract_days(~N[2017-01-01 10:20:00], 2)
      ~N[2016-12-30 10:20:00]
  
  """
  def subtract_days(date, days) do
    NaiveDateTime.add(date, -(3600 * 24 * days))    
  end

  @doc """
  Subtract `minutes` from `date`

  ## Examples

      iex> Bank.Utils.DateUtil.subtract_minutes(~N[2017-01-01 10:20:00], 2)
      ~N[2017-01-01 10:18:00]
  
  """
  def subtract_minutes(date, minutes) do
    NaiveDateTime.add(date, -(60 * minutes))    
  end
end

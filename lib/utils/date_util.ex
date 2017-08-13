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

  @doc """
  Return the datetime `NaiveDateTime`. `edge_time` can be used to specify if the time should represent
  `:start` (00:00:00.000) of the day or `:end` (23:59:59.999) or if no `edge_time` is passed it'll 
  return the passed date

  ## Examples

      iex> Bank.Utils.DateUtil.date_time(~N[2017-01-01 10:20:00])
      ~N[2017-01-01 10:20:00]

      iex> Bank.Utils.DateUtil.date_time(~N[2017-01-01 10:20:00], :start)
      ~N[2017-01-01 00:00:00]

      iex> Bank.Utils.DateUtil.date_time(~N[2017-01-01 10:20:00], :end)
      ~N[2017-01-01 23:59:59]
  
  """
  def date_time(datetime, edge_time \\ nil) do
    date = NaiveDateTime.to_date(datetime)
    {:ok, result_date} = case edge_time do
      :start -> NaiveDateTime.new(date, ~T[00:00:00])
      :end -> NaiveDateTime.new(date, ~T[23:59:59])
      _ -> {:ok, datetime}
    end
    result_date
  end
end

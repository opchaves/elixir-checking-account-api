defmodule Bank.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = start_supervised Bank.Bucket
    # ExUnit will merge this map into the test context
    %{bucket: bucket}
  end

  # extract the bucket from the test context (is a map) with pattern matching
  test "stores values by key", %{bucket: bucket} do
    assert Bank.Bucket.get(bucket, "123") == nil

    Bank.Bucket.put(bucket, "123", %{"number" => "123"})
    assert Bank.Bucket.get(bucket, "123") == %{"number" => "123"}
  end
end

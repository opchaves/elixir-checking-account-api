defmodule Bank.Bucket.BucketTest do
  use ExUnit.Case, async: true

  alias Bank.Bucket.Bucket

  setup do
    {:ok, bucket} = start_supervised Bucket
    # ExUnit will merge this map into the test context
    %{bucket: bucket}
  end

  # extract the bucket from the test context (is a map) with pattern matching
  test "stores values by key", %{bucket: bucket} do
    assert Bucket.get(bucket, "123") == nil

    Bucket.put(bucket, "123", %{"number" => "123"})
    assert Bucket.get(bucket, "123") == %{"number" => "123"}
  end
end

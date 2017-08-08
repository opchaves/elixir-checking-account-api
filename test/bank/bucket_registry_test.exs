defmodule Bank.BucketRegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = start_supervised Bank.BucketRegistry
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert Bank.BucketRegistry.lookup(registry, "operations") == :error

    Bank.BucketRegistry.create(registry, "operations")
    assert {:ok, bucket} = Bank.BucketRegistry.lookup(registry, "operations")

    Bank.Bucket.put(bucket, "123", %{"number" => "123"})
    assert Bank.Bucket.get(bucket, "123") == %{"number" => "123"}
  end

  test "removes buckets on exit", %{registry: registry} do
    Bank.BucketRegistry.create(registry, "operations")
    {:ok, bucket} = Bank.BucketRegistry.lookup(registry, "operations")
    Agent.stop(bucket)
    assert Bank.BucketRegistry.lookup(registry, "operations") == :error
  end
end

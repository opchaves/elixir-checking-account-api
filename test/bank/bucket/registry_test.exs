defmodule Bank.Bucket.RegistryTest do
  use ExUnit.Case, async: true

  alias Bank.Bucket.{Bucket, Registry}

  setup do
    {:ok, registry} = start_supervised Registry
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert Registry.lookup(registry, "operations") == :error

    Registry.create(registry, "operations")
    assert {:ok, bucket} = Registry.lookup(registry, "operations")

    Bucket.put(bucket, "123", %{"number" => "123"})
    assert Bucket.get(bucket, "123") == %{"number" => "123"}
  end

  test "removes buckets on exit", %{registry: registry} do
    Registry.create(registry, "operations")
    {:ok, bucket} = Registry.lookup(registry, "operations")
    Agent.stop(bucket)
    assert Registry.lookup(registry, "operations") == :error
  end
end

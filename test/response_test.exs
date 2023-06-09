defmodule Giteax.ResponseTest do
  use ExUnit.Case, async: true

  alias Giteax.Response

  describe "Response test" do
    test "handle/1 status 200-299" do
      assert {:ok, :body} = Response.handle({:ok, %Tesla.Env{status: 200, body: :body}})
      assert {:ok, :body} = Response.handle({:ok, %Tesla.Env{status: 299, body: :body}})
    end

    test "handle/1 status 300-511" do
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 100, body: :body}})
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 300, body: :body}})
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 300, body: :body}})
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 400, body: :body}})
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 511, body: :body}})
    end

    test "handle/1 error response" do
      assert {:error, :econnrefused} = Response.handle({:error, :econnrefused})
      assert {:error, "some error"} = Response.handle({:error, "some error"})
    end

    test "handle/1 unknown error" do
      assert {:error, "some error"} = Response.handle("some error")
      assert {:error, %{}} = Response.handle(%{})
    end

    test "handle/2 status 200-299" do
      assert {:ok, :body} = Response.handle({:ok, %Tesla.Env{status: 200, body: :body}}, &fun/1)
      assert {:ok, :body} = Response.handle({:ok, %Tesla.Env{status: 299, body: :body}}, &fun/1)
    end

    test "handle/2 status 300-511" do
      assert {:error, :body} =
               Response.handle({:ok, %Tesla.Env{status: 100, body: :body}}, &fun/1)

      assert {:error, :body} =
               Response.handle({:ok, %Tesla.Env{status: 300, body: :body}}, &fun/1)

      assert {:error, :body} =
               Response.handle({:ok, %Tesla.Env{status: 300, body: :body}}, &fun/1)

      assert {:error, :body} =
               Response.handle({:ok, %Tesla.Env{status: 400, body: :body}}, &fun/1)

      assert {:error, :body} =
               Response.handle({:ok, %Tesla.Env{status: 511, body: :body}}, &fun/1)
    end

    test "handle/2 error response" do
      assert {:error, :econnrefused} = Response.handle({:error, :econnrefused}, &fun/1)
      assert {:error, "some error"} = Response.handle({:error, "some error"}, &fun/1)
    end

    test "handle/2 unknown error" do
      assert {:error, "some error"} = Response.handle("some error", &fun/1)
      assert {:error, %{}} = Response.handle(%{}, &fun/1)
    end
  end

  defp fun(term), do: term
end

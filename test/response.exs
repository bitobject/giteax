defmodule Giteax.ResponseTest do
  use ExUnit.Case, async: true

  alias Giteax.Response

  describe "Response test" do
    test "handle/1" do
      assert {:ok, :body} = Response.handle({:ok, %Tesla.Env{status: 200, body: :body}})
      assert {:ok, :body} = Response.handle({:ok, %Tesla.Env{status: 299, body: :body}})

      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 300, body: :body}})
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 400, body: :body}})
      assert {:error, :body} = Response.handle({:ok, %Tesla.Env{status: 500, body: :body}})

      assert {:error, :econnrefused} = Response.handle({:error, :econnrefused})
      assert {:error, "some error"} = Response.handle({:error, "some error"})
    end
  end
end

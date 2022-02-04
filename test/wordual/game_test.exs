defmodule Wordual.GameTest do
  use ExUnit.Case

  import Wordual.Test.Support.Assertions

  alias Wordual.Game

  describe "init/2" do
    test "it starts in the :starting state" do
      result = Game.init("abc123", "swole")
      assert result.id == "abc123"
      assert result.word == "swole"
      assert result.state == :starting
      assert result.boards == %{}
    end
  end

  describe "add_char/3" do
    @tag :skip
    test "it should return an error if the game has not started" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.add_char("flerpn1", "a")

      assert result = {:error, :not_started}
    end

    @tag :skip
    test "it should add a letter to the current row" do
      {:ok, result} =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")
        |> Game.add_char("flerpn1", "a")

      first_row = List.first(result.boards["flerpn1"])

      assert first_row == [%{char: "a"}, %{}, %{}, %{}, %{}]
    end
  end

  describe "join/2" do
    test "It initializes the board for the players" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")

      result.boards
      |> Map.get("flerpn1")
      |> is_initiailzied_board()

      result.boards
      |> Map.get("flerpn2")
      |> is_initiailzied_board()
    end

    test "It only allows the player to join once" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn1")

      assert Map.keys(result.boards) == ["flerpn1"]
    end

    test "It doesn't allow a 3rd person to join" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")
        |> Game.join("flerpn2")
        |> Game.join("flerpn3")

      assert Map.keys(result.boards) == ["flerpn1", "flerpn2"]
    end

    test "It changes the state to :in_progress once both players have joined" do
      result =
        Game.init("abc123", "swole")
        |> Game.join("flerpn1")

      assert result.state == :starting

      result = Game.join(result, "flerpn2")

      assert result.state == :in_progress
    end
  end
end

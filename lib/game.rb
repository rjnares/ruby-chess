# frozen_string_literal: true

require_relative 'game_io'
require_relative 'board'
require_relative 'rules'

# Class for a chess game
class Game
  include GameIO

  def initialize(board = Board.new)
    @board = board
    @turn_color = Rules::WHITE
  end

  def play
    welcome
    play_turns
  end

  private

  attr_reader :board, :turn_color

  def play_turns
    loop do
      display_moves
    end
  end

  def valid_position?(position)
    # Currently, a valid position is in bounds and is non-empty. In the future, there
    # may need to be logic that looks for other higher priority conditions (e.g. check) which
    # makes it so a given position is not valid and the user must select another
    return false if out_of_bounds?(position) || empty_position?(position)

    true
  end

  def out_of_bounds?(position)
    return false unless board.out_of_bounds?(position)

    position_out_of_bounds(position)
    true
  end

  def empty_position?(position)
    return false unless board.empty_position?(position)

    position_empty(position)
    true
  end
end

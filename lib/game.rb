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
      moves = display_moves
      puts "Moves: #{moves}"
    end
  end

  def valid_position?(position)
    # Currently, a valid position is in bounds and is non-empty. In the future, there
    # may need to be logic that looks for other higher priority conditions (e.g. check) which
    # makes it so a given position is not valid and the user must select another
    if Rules.out_of_bounds?(position)
      position_out_of_bounds
      return false
    end

    if board.empty?(position)
      position_empty(position)
      return false
    end

    true
  end
end

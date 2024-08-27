# frozen_string_literal: true

require_relative 'game_io'
require_relative 'board'

# Class for a chess game
class Game
  include GameIO

  def initialize(board = Board.new)
    @board = board
  end

  def play
    welcome
    board.display
  end

  private

  attr_reader :board
end

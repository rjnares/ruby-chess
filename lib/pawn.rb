# frozen_string_literal: true

require_relative 'piece'

# Class for a pawn chess piece
class Pawn
  include Piece

  UNICODE = "\u265F"

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def available_moves(board, row, column)
    # Stubbing implementation for now
    [row, column]
  end
end

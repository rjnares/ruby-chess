# frozen_string_literal: true

require_relative 'piece'
require_relative 'rules'

# Class for a pawn chess piece
class Pawn
  include Piece

  UNICODE = "\u265F"

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def available_moves(board, row, column)
    forward_moves(board, row, column)
  end

  private

  def forward_moves(board, row, column, moves = [])
    next_row = forward_row(row)
    position = Rules.row_column_to_position(next_row, column)
    return moves unless position && board.empty?(position)

    moves << [next_row, column]
    return moves unless row == start_row

    next_row = forward_row(next_row)
    position = Rules.row_column_to_position(next_row, column)
    return moves unless position && board.empty?(position)

    moves << [next_row, column]
  end

  def forward_row(current_row)
    color == Rules::WHITE ? current_row - 1 : current_row + 1
  end

  def start_row
    color == Rules::WHITE ? Rules::WHITE_PAWNS_START_ROW : Rules::BLACK_PAWNS_START_ROW
  end
end

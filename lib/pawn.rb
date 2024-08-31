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

  def forward_moves(board, row, column)
    source_position = Rules.row_column_to_position(row, column)
    return [] unless source_position

    possible_moves(row, column).each_with_object([]) do |(r, c), moves|
      target_position = Rules.row_column_to_position(r, c)
      return moves unless target_position && board.empty?(target_position)

      moves << Rules.notate_move(source_position, target_position)
    end
  end

  def possible_moves(row, column, moves = [])
    moves << (color == Rules::WHITE ? [row - 1, column] : [row + 1, column])
    return moves unless row == start_row

    moves << (color == Rules::WHITE ? [row - 2, column] : [row + 2, column])
  end

  def start_row
    color == Rules::WHITE ? Rules::WHITE_PAWNS_START_ROW : Rules::BLACK_PAWNS_START_ROW
  end
end

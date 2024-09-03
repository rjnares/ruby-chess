# frozen_string_literal: true

require_relative 'piece'
require_relative 'rules'

# Class for a rook chess piece
class Rook
  include Piece

  UNICODE = "\u265C"

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def available_moves(board, row, column)
    default_moves(board, row, column)
  end

  private

  def default_moves(board, row, column, moves = [])
    source_position = Rules.row_column_to_position(row, column)
    return moves if source_position.nil?

    add_moves(board, source_position, [row - 1, column], moves) { |r, c| [r - 1, c] }
    add_moves(board, source_position, [row + 1, column], moves) { |r, c| [r + 1, c] }
    add_moves(board, source_position, [row, column - 1], moves) { |r, c| [r, c - 1] }
    add_moves(board, source_position, [row, column + 1], moves) { |r, c| [r, c + 1] }

    moves
  end

  def add_moves(board, source_position, target_row_col, moves, &target_row_col_update)
    return unless block_given?

    target_position = Rules.row_column_to_position(target_row_col[0], target_row_col[1])

    until target_position.nil?
      piece = board.piece(target_position)
      moves << Rules.notate_capture(Rules::ROOK_NOTATION, source_position, target_position) if enemy?(piece)
      return unless piece.nil?

      moves << Rules.notate_move(Rules::ROOK_NOTATION, source_position, target_position)
      target_row_col = target_row_col_update.call(target_row_col)
      target_position = Rules.row_column_to_position(target_row_col[0], target_row_col[1])
    end
  end
end

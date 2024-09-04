# frozen_string_literal: true

require_relative 'piece'
require_relative 'rules'

# Class for a queen chess piece
class Queen
  include Piece

  UNICODE = "\u265B"

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def available_moves(board, row, column)
    source_position = Rules.row_column_to_position(row, column)
    return [] if source_position.nil?

    bishop_moves(source_position, board, row, column) +
      rook_moves(source_position, board, row, column)
  end

  private

  def rook_moves(source_position, board, row, column)
    rook_moves_vertical(source_position, board, row, column) +
      rook_moves_horizontal(source_position, board, row, column)
  end

  def rook_moves_vertical(source_position, board, row, column, moves = [])
    add_moves(moves, source_position, board, row - 1, column) { |r, c| [r - 1, c] }
    add_moves(moves, source_position, board, row + 1, column) { |r, c| [r + 1, c] }
    moves
  end

  def rook_moves_horizontal(source_position, board, row, column, moves = [])
    add_moves(moves, source_position, board, row, column - 1) { |r, c| [r, c - 1] }
    add_moves(moves, source_position, board, row, column + 1) { |r, c| [r, c + 1] }
    moves
  end

  def bishop_moves(source_position, board, row, column)
    bishop_moves_up(source_position, board, row, column) +
      bishop_moves_down(source_position, board, row, column)
  end

  def bishop_moves_up(source_position, board, row, column, moves = [])
    add_moves(moves, source_position, board, row - 1, column - 1) { |r, c| [r - 1, c - 1] }
    add_moves(moves, source_position, board, row - 1, column + 1) { |r, c| [r - 1, c + 1] }
    moves
  end

  def bishop_moves_down(source_position, board, row, column, moves = [])
    add_moves(moves, source_position, board, row + 1, column - 1) { |r, c| [r + 1, c - 1] }
    add_moves(moves, source_position, board, row + 1, column + 1) { |r, c| [r + 1, c + 1] }
    moves
  end

  def add_moves(moves, source_position, board, row, column)
    return unless block_given?

    target_position = Rules.row_column_to_position(row, column)

    until target_position.nil?
      piece = board.piece(target_position)
      moves << Rules.notate_capture(Rules::QUEEN_NOTATION, source_position, target_position) if enemy?(piece)
      return unless piece.nil?

      moves << Rules.notate_move(Rules::QUEEN_NOTATION, source_position, target_position)
      row, column = yield(row, column)
      target_position = Rules.row_column_to_position(row, column)
    end
  end
end

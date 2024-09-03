# frozen_string_literal: true

require_relative 'piece'

# Class for a king chess piece
class King
  include Piece

  UNICODE = "\u265A"

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def available_moves(board, row, column)
    default_moves(board, row, column)
  end

  private

  def default_moves(board, row, column)
    source_position = Rules.row_column_to_position(row, column)
    return [] if source_position.nil?

    target_positions(row, column).each_with_object([]) do |target_position, moves|
      piece = board.piece(target_position)

      if piece.nil?
        moves << Rules.notate_move(Rules::KING_NOTATION, source_position, target_position)
      elsif enemy?(piece)
        moves << Rules.notate_capture(Rules::KING_NOTATION, source_position, target_position)
      end
    end
  end

  def target_positions(row, column)
    possible_moves(row, column).each_with_object([]) do |(r, c), positions|
      position = Rules.row_column_to_position(r, c)
      positions << position unless position.nil?
    end
  end

  def possible_moves(row, column)
    [
      [row - 1, column - 1],
      [row - 1, column],
      [row - 1, column + 1],
      [row, column - 1],
      [row, column + 1],
      [row + 1, column - 1],
      [row + 1, column],
      [row + 1, column + 1]
    ]
  end
end

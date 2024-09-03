# frozen_string_literal: true

require_relative 'piece'
require_relative 'rules'

# Class for a knight chess piece
class Knight
  include Piece

  UNICODE = "\u265E"

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def available_moves(board, row, column)
    source_position = Rules.row_column_to_position(row, column)
    return [] if source_position.nil?

    target_positions(row, column).each_with_object([]) do |target_position, moves|
      piece = board.piece(target_position)

      if piece.nil?
        moves << Rules.notate_move(Rules::KNIGHT_NOTATION, source_position, target_position)
      elsif enemy?(piece)
        moves << Rules.notate_capture(Rules::KNIGHT_NOTATION, source_position, target_position)
      end
    end
  end

  private

  def target_positions(row, column)
    possible_moves(row, column).each_with_object([]) do |(r, c), positions|
      position = Rules.row_column_to_position(r, c)
      positions << position unless position.nil?
    end
  end

  def possible_moves(row, column)
    [
      [row - 2, column - 1],
      [row - 2, column + 1],
      [row - 1, column + 2],
      [row + 1, column + 2],
      [row + 2, column + 1],
      [row + 2, column - 1],
      [row + 1, column - 2],
      [row - 1, column - 2]
    ]
  end
end

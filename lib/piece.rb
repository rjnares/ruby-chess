# frozen_string_literal: true

# Module for common chess piece functionality
module Piece
  def to_s
    self.class::UNICODE.colorize(color)
  end

  def enemy?(piece)
    return false if piece.nil?

    color != piece.color
  end
end

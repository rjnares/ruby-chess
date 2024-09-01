# frozen_string_literal: true

require_relative 'piece'

# Class for a rook chess piece
class Rook
  include Piece

  UNICODE = "\u265C"

  attr_reader :color

  def initialize(color)
    @color = color
  end
end

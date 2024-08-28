# frozen_string_literal: true

# Module with helper variables and methods to enforce chess rules
module Rules
  NUM_RANKS = 8
  NUM_FILES = 8

  LIGHT_SQUARE_COLOR = :light_white
  DARK_SQUARE_COLOR = :white

  FILES = %w[a b c d e f g h].freeze

  WHITE_PAWNS_START_ROW = 6
  BLACK_PAWNS_START_ROW = 1

  WHITE = :gray
  BLACK = :black
end

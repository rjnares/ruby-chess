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

  RANK_TO_ROW_MAP = {
    '8' => 0,
    '7' => 1,
    '6' => 2,
    '5' => 3,
    '4' => 4,
    '3' => 5,
    '2' => 6,
    '1' => 7
  }.freeze

  FILE_TO_COLUMN_MAP = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }.freeze

  def self.position_to_row_column(position)
    return if position.length != 2

    file = position[0]
    rank = position[1]

    row = RANK_TO_ROW_MAP[rank]
    column = FILE_TO_COLUMN_MAP[file]

    return if row.nil? || column.nil?

    [row, column]
  end
end

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

  WHITE_PAWNS_PROMOTION_ROW = 0
  BLACK_PAWNS_PROMOTION_ROW = 7

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

  ROW_TO_RANK_MAP = {
    0 => '8',
    1 => '7',
    2 => '6',
    3 => '5',
    4 => '4',
    5 => '3',
    6 => '2',
    7 => '1'
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

  COLUMN_TO_FILE_MAP = {
    0 => 'a',
    1 => 'b',
    2 => 'c',
    3 => 'd',
    4 => 'e',
    5 => 'f',
    6 => 'g',
    7 => 'h'
  }.freeze

  PAWN_NOTATION = ''
  ROOK_NOTATION = 'R'
  KING_NOTATION = 'K'
  KNIGHT_NOTATION = 'N'
  BISHOP_NOTATION = 'B'

  PAWN_MOVE_POSITION_SKIP_MAP = {
    'a7-a5' => 'a6',
    'b7-b5' => 'b6',
    'c7-c5' => 'c6',
    'd7-d5' => 'd6',
    'e7-e5' => 'e6',
    'f7-f5' => 'f6',
    'g7-g5' => 'g6',
    'h7-h5' => 'h6',
    'a2-a4' => 'a3',
    'b2-b4' => 'b3',
    'c2-c4' => 'c3',
    'd2-d4' => 'd3',
    'e2-e4' => 'e3',
    'f2-f4' => 'f3',
    'g2-g4' => 'g3',
    'h2-h4' => 'h3'
  }.freeze

  def self.out_of_bounds?(position)
    return true if position&.length != 2

    file = position[0]
    rank = position[1]

    row = RANK_TO_ROW_MAP[rank]
    column = FILE_TO_COLUMN_MAP[file]

    row.nil? || column.nil?
  end

  def self.position_to_row_column(position)
    return if position&.length != 2

    file = position[0]
    rank = position[1]

    row = RANK_TO_ROW_MAP[rank]
    column = FILE_TO_COLUMN_MAP[file]

    return if row.nil? || column.nil?

    [row, column]
  end

  def self.row_column_to_position(row, column)
    file = COLUMN_TO_FILE_MAP[column]
    rank = ROW_TO_RANK_MAP[row]

    return if file.nil? || rank.nil?

    file + rank
  end

  def self.notate_pawn_promotion(source_position, target_position)
    return if source_position.nil? || target_position.nil?

    "#{PAWN_NOTATION}#{source_position}-#{target_position}="
  end

  def self.notate_move(piece_notation = PAWN_NOTATION, source_position, target_position)
    return if source_position.nil? || target_position.nil?

    "#{piece_notation}#{source_position}-#{target_position}"
  end

  def self.notate_capture(piece_notation = PAWN_NOTATION, source_position, target_position)
    return if source_position.nil? || target_position.nil?

    "#{piece_notation}#{source_position}x#{target_position}"
  end

  def self.notate_en_passant_capture(piece_notation = PAWN_NOTATION, source_position, target_position)
    return if source_position.nil? || target_position.nil?

    "#{piece_notation}#{source_position}x#{target_position}ep"
  end

  def self.parse_move_landing_position(move)
    return if move.nil?

    position = move[-2..] || ''
    return if out_of_bounds?(position)

    position
  end
end

# frozen_string_literal: true

require 'colorize'

require_relative 'rules'
require_relative 'pawn'
require_relative 'rook'
require_relative 'king'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'

# Class for a chess board
class Board
  attr_reader :last_move

  def initialize
    @last_move = nil
    @grid = Array.new(Rules::NUM_RANKS) { Array.new(Rules::NUM_FILES) }

    create_pawns
    create_rooks
    create_kings
    create_knights
    create_bishops
    create_queens
  end

  def display
    display_file_labels
    display_rows
  end

  def empty?(position)
    row_col = Rules.position_to_row_column(position)
    return true if row_col.nil?

    row = row_col[0]
    col = row_col[1]

    grid[row][col].nil?
  end

  def available_moves(position)
    row_col = Rules.position_to_row_column(position)
    return [] if row_col.nil?

    row = row_col[0]
    col = row_col[1]
    piece = grid[row][col]

    return [] if piece.nil?

    piece.available_moves(self, row, col)
  end

  def piece(position)
    row_col = Rules.position_to_row_column(position)
    return if row_col.nil?

    row = row_col[0]
    col = row_col[1]

    grid[row][col]
  end

  private

  attr_reader :grid
  attr_writer :last_move

  def create_queens
    grid[7][3] = Queen.new(Rules::WHITE)
    grid[0][3] = Queen.new(Rules::BLACK)
  end

  def create_bishops
    grid[7][2] = Bishop.new(Rules::WHITE)
    grid[7][5] = Bishop.new(Rules::WHITE)
    grid[0][2] = Bishop.new(Rules::BLACK)
    grid[0][5] = Bishop.new(Rules::BLACK)
  end

  def create_knights
    grid[7][1] = Knight.new(Rules::WHITE)
    grid[7][6] = Knight.new(Rules::WHITE)
    grid[0][1] = Knight.new(Rules::BLACK)
    grid[0][6] = Knight.new(Rules::BLACK)
  end

  def create_kings
    grid[7][4] = King.new(Rules::WHITE)
    grid[0][4] = King.new(Rules::BLACK)
  end

  def create_rooks
    grid[0][0] = Rook.new(Rules::BLACK)
    grid[0][7] = Rook.new(Rules::BLACK)
    grid[7][0] = Rook.new(Rules::WHITE)
    grid[7][7] = Rook.new(Rules::WHITE)
  end

  def create_pawns
    (0...Rules::NUM_FILES).each do |column_index|
      grid[Rules::WHITE_PAWNS_START_ROW][column_index] = Pawn.new(Rules::WHITE)
      grid[Rules::BLACK_PAWNS_START_ROW][column_index] = Pawn.new(Rules::BLACK)
    end
  end

  def display_file_labels
    puts
    file_labels = [' '] + Rules::FILES
    file_labels.each { |val| print " #{val} " }
    puts
  end

  def display_rows
    start_light = true
    grid.each_with_index do |row, idx|
      display_row(row, Rules::NUM_RANKS - idx, start_light)
      start_light = !start_light
    end
  end

  def display_row(row, rank_label, light_square)
    print " #{rank_label} "

    row.each do |val|
      color = light_square ? Rules::LIGHT_SQUARE_COLOR : Rules::DARK_SQUARE_COLOR
      print " #{val || ' '} ".colorize(background: color)
      light_square = !light_square
    end

    puts
  end
end

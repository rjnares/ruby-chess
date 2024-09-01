# frozen_string_literal: true

require 'colorize'

require_relative 'rules'
require_relative 'pawn'

# Class for a chess board
class Board
  attr_reader :last_move

  def initialize
    @last_move = nil
    @grid = Array.new(Rules::NUM_RANKS) { Array.new(Rules::NUM_FILES) }

    create_pawns(@grid[Rules::WHITE_PAWNS_START_ROW], Rules::WHITE)
    create_pawns(@grid[Rules::BLACK_PAWNS_START_ROW], Rules::BLACK)
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

  def create_pawns(row, color)
    row.each_index { |idx| row[idx] = Pawn.new(color) }
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

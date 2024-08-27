# frozen_string_literal: true

require 'colorize'

require_relative 'rules'

# Class for a chess board
class Board
  def initialize
    @grid = Array.new(Rules::NUM_RANKS) { Array.new(Rules::NUM_FILES) }
  end

  def display
    display_file_labels
    display_rows
  end

  private

  attr_reader :grid

  def display_file_labels
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

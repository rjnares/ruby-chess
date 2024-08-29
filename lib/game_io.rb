# frozen_string_literal: true

# Module for chess game input/output
module GameIO
  def welcome
    puts <<~HEREDOC

      Welcome to my chess game built with Ruby!
    HEREDOC
  end

  def enter_grid_position
    board.display
    puts <<~HEREDOC

      Current turn: #{turn_color == Rules::WHITE ? 'white' : 'black'}
    HEREDOC
    print 'Enter a position on the grid to see available moves: '
  end

  def position_out_of_bounds
    puts <<~HEREDOC

      Position is out of bounds, please try again...
    HEREDOC
  end

  def position_empty(position)
    puts <<~HEREDOC

      Position [#{position}] is empty, please try again...
    HEREDOC
  end

  def grid_position
    loop do
      enter_grid_position
      position = gets.chomp.downcase
      return position if valid_position?(position)
    end
  end

  def display_moves
    grid_position
  end
end

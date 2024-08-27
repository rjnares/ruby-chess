# frozen_string_literal: true

require_relative 'game_io'

# Class for a chess game
class Game
  include GameIO

  def play
    welcome
  end
end

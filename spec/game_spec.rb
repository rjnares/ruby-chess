# frozen_string_literal: true

require_relative '../lib/game'

RSpec.describe Game do
  let(:board) { double('board') }
  subject(:game) { described_class.new(board) }

  describe '#initialize' do
    context 'when board instance is not passed as arguement' do
      subject(:new_game) { described_class.new }

      it 'creates a new board instance' do
        expect(new_game.instance_variable_get(:@board)).not_to eq(board)
      end
    end

    context 'when board instance is passed as argument' do
      it 'sets it as the board instance variable' do
        expect(game.instance_variable_get(:@board)).to eq(board)
      end
    end

    it 'sets @turn_color to value of Rules::WHITE' do
      expected = 'expected'
      stub_const('Rules::WHITE', expected)
      expect(game.instance_variable_get(:@turn_color)).to eq(expected)
    end
  end

  describe '#play' do
    before do
      allow(game).to receive(:welcome)
      allow(game).to receive(:play_turns)
    end

    it 'calls GameIO#welcome once' do
      expect(game).to receive(:welcome).once
      game.play
    end

    it 'calls #play_turns once' do
      expect(game).to receive(:play_turns).once
      game.play
    end
  end

  describe 'GameIO#grid_position' do
    let(:input) { double('input') }
    let(:chomped_input) { double('chomped_input') }
    let(:position) { 'position' }

    before do
      allow(game).to receive(:enter_grid_position)
      allow(game).to receive(:gets).and_return(input)
      allow(input).to receive(:chomp).and_return(chomped_input)
      allow(chomped_input).to receive(:downcase).and_return(position)
    end

    context 'when position is valid' do
      before do
        allow(game).to receive(:valid_position?).and_return(true)
      end

      it 'returns the position' do
        expect(game.grid_position).to eq(position)
      end
    end

    context 'when position is invalid once' do
      before do
        allow(game).to receive(:valid_position?).and_return(false, true)
      end

      it 'calls GameIO#enter_grid_position twice' do
        expect(game).to receive(:enter_grid_position).twice
        game.grid_position
      end

      it 'calls Kernel#gets twice' do
        expect(game).to receive(:gets).twice
        game.grid_position
      end

      it 'calls String#chomp twice' do
        expect(input).to receive(:chomp).twice
        game.grid_position
      end

      it 'calls String#downcase twice' do
        expect(chomped_input).to receive(:downcase).twice
        game.grid_position
      end

      it 'calls #valid_position? twice' do
        expect(game).to receive(:valid_position?).twice
        game.grid_position
      end
    end

    context 'when position is invalid 5 times' do
      before do
        allow(game).to receive(:valid_position?).and_return(false, false, false, false, false, true)
      end

      it 'calls GameIO#enter_grid_position 6 times' do
        expect(game).to receive(:enter_grid_position).exactly(6).times
        game.grid_position
      end

      it 'calls Kernel#gets 6 times' do
        expect(game).to receive(:gets).exactly(6).times
        game.grid_position
      end

      it 'calls String#chomp 6 times' do
        expect(input).to receive(:chomp).exactly(6).times
        game.grid_position
      end

      it 'calls String#downcase 6 times' do
        expect(chomped_input).to receive(:downcase).exactly(6).times
        game.grid_position
      end

      it 'calls #valid_position? 6 times' do
        expect(game).to receive(:valid_position?).exactly(6).times
        game.grid_position
      end
    end
  end

  describe 'GameIO#display_moves' do
    before do
      allow(game).to receive(:grid_position)
    end

    it 'calls GameIO#grid_position once' do
      expect(game).to receive(:grid_position).once
      game.display_moves
    end
  end
end

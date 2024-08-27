# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
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
  end

  describe '#play' do
    before do
      allow(game).to receive(:welcome)
      allow(board).to receive(:display)
    end

    it 'calls #welcome once' do
      expect(game).to receive(:welcome).once
      game.play
    end
  end
end

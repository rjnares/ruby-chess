# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#play' do
    before do
      allow(game).to receive(:welcome)
    end

    it 'calls #welcome once' do
      expect(game).to receive(:welcome).once
      game.play
    end
  end
end

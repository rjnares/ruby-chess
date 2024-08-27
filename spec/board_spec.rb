# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  let(:grid) { board.instance_variable_get(:@grid) }
  subject(:board) { described_class.new }

  describe '#initialize' do
    it 'creates a grid with 8 rows' do
      expect(grid.length).to eq(8)
    end

    it 'creates a grid with 8 columns' do
      expect(grid.all? { |row| row.length == 8 }).to eq(true)
    end
  end

  describe '#display' do
    before do
      allow(board).to receive(:display_file_labels)
      allow(board).to receive(:display_rows)
    end

    it 'calls #display_file_labels once' do
      expect(board).to receive(:display_file_labels).once
      board.display
    end

    it 'calls #display_rows once' do
      expect(board).to receive(:display_rows).once
      board.display
    end
  end
end

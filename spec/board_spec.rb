# frozen_string_literal: true

require_relative '../lib/board'

RSpec.describe Board do
  let(:grid) { board.instance_variable_get(:@grid) }
  subject(:board) { described_class.new }

  describe '#initialize' do
    it 'creates a grid with 8 rows' do
      expect(grid.length).to eq(8)
    end

    it 'creates a grid with 8 columns' do
      expect(grid.all? { |row| row.length == 8 }).to eq(true)
    end

    context 'when pawns are created' do
      it 'adds black pawns to row 1' do
        result = grid[1].all? do |val|
          val.instance_of?(Pawn) && val.color == :black
        end
        expect(result).to eq(true)
      end

      it 'adds white pawns to row 6' do
        result = grid[6].all? do |val|
          val.instance_of?(Pawn) && val.color == :gray
        end
        expect(result).to eq(true)
      end
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

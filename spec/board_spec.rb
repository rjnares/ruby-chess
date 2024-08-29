# frozen_string_literal: true

require_relative '../lib/board'

RSpec.describe Board do
  let(:rules) { class_double('Rules').as_stubbed_const(transfer_nested_constants: true) }
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

  describe '#out_of_bounds?' do
    let(:position) { 'position' }

    context 'when Rules::position_to_row_column returns nil' do
      before do
        allow(rules).to receive(:position_to_row_column)
      end

      it 'returns true' do
        expect(board.out_of_bounds?(position)).to eq(true)
      end
    end

    context 'when Rules::position_to_row_column does not return nil' do
      before do
        allow(rules).to receive(:position_to_row_column).and_return([1, 2])
      end

      it 'returns false' do
        expect(board.out_of_bounds?(position)).to eq(false)
      end
    end
  end

  describe '#empty_position?' do
    let(:position) { 'position' }

    context 'when Rules::position_to_row_column returns nil' do
      before do
        allow(rules).to receive(:position_to_row_column)
      end

      it 'returns true' do
        expect(board.empty_position?(position)).to eq(true)
      end
    end

    context 'when Rules::position_to_row_column does not return nil' do
      let(:row) { 1 }
      let(:column) { 2 }

      before do
        allow(rules).to receive(:position_to_row_column).and_return([row, column])
      end

      context 'when position is nil' do
        before do
          grid[row][column] = nil
        end

        it 'returns true' do
          expect(board.empty_position?(position)).to eq(true)
        end
      end

      context 'when position is not nil' do
        before do
          grid[row][column] = double('pawn')
        end

        it 'returns false' do
          expect(board.empty_position?(position)).to eq(false)
        end
      end
    end
  end
end

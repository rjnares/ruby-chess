# frozen_string_literal: true

require_relative '../lib/knight'

RSpec.describe Knight do
  let(:white_knight) { described_class.new(:white) }
  let(:black_knight) { described_class.new(:black) }
  let(:board) { instance_double('board') }

  it 'returns knight unicode' do
    expect(described_class::UNICODE).to eq("\u265E")
  end

  describe '#initialize' do
    let(:expected_color) { 'expected_color' }
    subject(:knight) { described_class.new(expected_color) }

    it 'sets the color instance variable' do
      expect(knight.instance_variable_get(:@color)).to eq(expected_color)
    end
  end

  describe '#available_moves' do
    let(:row) { 2 }
    let(:column) { 4 }
    let(:positions) { %w[p1 p2 p3] }

    context 'when knight is white' do
      context 'when source position is nil' do
        it 'returns empty array' do
          expect(white_knight.available_moves(board, -1, -1)).to eq([])
        end
      end

      context 'when target positions are empty' do
        before do
          allow(white_knight).to receive(:target_positions).and_return(positions)
          allow(board).to receive(:piece).and_return(nil)
        end

        it 'returns knight moves' do
          result = white_knight.available_moves(board, row, column)
          expect(result).to eq(%w[Ne6-p1 Ne6-p2 Ne6-p3])
        end
      end

      context 'when target positions have friendly pieces' do
        let(:friendly) { double('friendly') }

        before do
          allow(white_knight).to receive(:target_positions).and_return(positions)
          allow(board).to receive(:piece).and_return(friendly)
          allow(white_knight).to receive(:enemy?).and_return(false)
        end

        it 'returns empty array' do
          result = white_knight.available_moves(board, row, column)
          expect(result).to eq([])
        end
      end

      context 'when target positions have enemy pieces' do
        let(:enemy) { double('enemy') }

        before do
          allow(white_knight).to receive(:target_positions).and_return(positions)
          allow(board).to receive(:piece).and_return(enemy)
          allow(white_knight).to receive(:enemy?).and_return(true)
        end

        it 'returns knight captures' do
          result = white_knight.available_moves(board, row, column)
          expect(result).to eq(%w[Ne6xp1 Ne6xp2 Ne6xp3])
        end
      end
    end
  end

  describe '#color' do
    context 'when knight is white' do
      it 'returns white' do
        expect(white_knight.color).to eq(:white)
      end
    end

    context 'when knight is black' do
      it 'returns black' do
        expect(black_knight.color).to eq(:black)
      end
    end
  end
end

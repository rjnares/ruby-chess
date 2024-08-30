# frozen_string_literal: true

require_relative '../lib/pawn'

RSpec.describe Pawn do
  let(:board) { instance_double('Board') }
  let(:white_pawn) { described_class.new(:gray) }
  let(:black_pawn) { described_class.new(:black) }
  it 'has the pawn unicode constant' do
    expect(described_class::UNICODE).to eq("\u265F")
  end

  describe '#initialize' do
    it 'sets the color instance variable' do
      expect(white_pawn.instance_variable_get(:@color)).to eq(:gray)
    end
  end

  describe '#color' do
    it 'returns the color instance variable value' do
      expect(white_pawn.color).to eq(:gray)
    end
  end

  describe '#to_s' do
    let(:unicode_str) { double('unicode_str') }
    let(:colorized_str) { 'colorized_str' }

    before do
      allow(unicode_str).to receive(:colorize).and_return(colorized_str)
      allow(white_pawn).to receive(:color).and_return(:gray)
    end

    it 'calls #colorize on unicode string once' do
      stub_const("#{described_class}::UNICODE", unicode_str)
      expect(unicode_str).to receive(:colorize).with(:gray).once
      white_pawn.to_s
    end

    it 'returns the colorized unicode string' do
      stub_const("#{described_class}::UNICODE", unicode_str)
      expect(white_pawn.to_s).to eq(colorized_str)
    end
  end

  describe '#available_moves' do
    let(:column) { 0 }

    context 'when pawn is white' do
      context 'when pawn is on starting row' do
        let(:row) { 6 }

        context 'when both forward spaces are available' do
          before do
            allow(board).to receive(:empty?).and_return(true, true)
          end

          it 'returns [[row-1, column], row-2, column]]' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([[row - 1, column], [row - 2, column]])
          end
        end

        context 'when only the first forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(true, false)
          end

          it 'returns [[row-1, column]]' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([[row - 1, column]])
          end
        end

        context 'when only the second forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, true)
          end

          it 'returns []' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when no forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, false)
          end

          it 'returns []' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end

      context 'when pawn is not on starting row' do
        let(:row) { 4 }

        context 'when a forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(true)
          end

          it 'returns [[row-1, column]]' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([[row - 1, column]])
          end
        end

        context 'when a forward space is not available' do
          before do
            allow(board).to receive(:empty?).and_return(false)
          end

          it 'returns []' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end
    end

    context 'when pawn is black' do
      context 'when pawn is on starting row' do
        let(:row) { 1 }

        context 'when both forward spaces are available' do
          before do
            allow(board).to receive(:empty?).and_return(true, true)
          end

          it 'returns [[row+1, column], [row+2, column]]' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([[row + 1, column], [row + 2, column]])
          end
        end

        context 'when only the first forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(true, false)
          end

          it 'returns [[row+1, column]]' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([[row + 1, column]])
          end
        end

        context 'when only the second forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, true)
          end

          it 'returns []' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when no forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, false)
          end

          it 'returns []' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end

      context 'when pawn is not on starting row' do
        let(:row) { 4 }

        context 'when a forward space is available' do
          before do
            allow(board).to receive(:empty?).and_return(true)
          end

          it 'returns [[row+1, column]]' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([[row + 1, column]])
          end
        end

        context 'when a forward space is not available' do
          before do
            allow(board).to receive(:empty?).and_return(false)
          end

          it 'returns []' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end
    end
  end
end

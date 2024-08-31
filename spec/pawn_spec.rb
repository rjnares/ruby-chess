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
        let(:move1) { 'a2 - a3' }
        let(:move2) { 'a2 - a4' }

        context 'when both forward positions are available' do
          before do
            allow(board).to receive(:empty?).and_return(true, true)
          end

          it 'returns both moves' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([move1, move2])
          end
        end

        context 'when only the first forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(true, false)
          end

          it 'returns the first move' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([move1])
          end
        end

        context 'when only the second forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, true)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when no forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, false)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end

      context 'when pawn is not on starting row' do
        let(:row) { 4 }
        let(:move1) { 'a4 - a5' }

        context 'when the first forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(true)
          end

          it 'returns the first move' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([move1])
          end
        end

        context 'when a forward position is not available' do
          before do
            allow(board).to receive(:empty?).and_return(false)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end
    end

    context 'when pawn is black' do
      context 'when pawn is on starting row' do
        let(:row) { 1 }
        let(:move1) { 'a7 - a6' }
        let(:move2) { 'a7 - a5' }

        context 'when both forward positions are available' do
          before do
            allow(board).to receive(:empty?).and_return(true, true)
          end

          it 'returns both moves' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([move1, move2])
          end
        end

        context 'when only the first forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(true, false)
          end

          it 'returns the first move' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([move1])
          end
        end

        context 'when only the second forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, true)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when no forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(false, false)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end

      context 'when pawn is not on starting row' do
        let(:row) { 4 }
        let(:move1) { 'a4 - a3' }

        context 'when the first forward position is available' do
          before do
            allow(board).to receive(:empty?).and_return(true)
          end

          it 'returns the first move' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([move1])
          end
        end

        context 'when a forward position is not available' do
          before do
            allow(board).to receive(:empty?).and_return(false)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end
      end
    end
  end
end

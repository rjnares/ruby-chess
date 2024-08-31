# frozen_string_literal: true

require_relative '../lib/pawn'

RSpec.describe Pawn do
  let(:board) { instance_double('Board') }
  let(:white_pawn) { described_class.new(:gray) }
  let(:black_pawn) { described_class.new(:black) }
  let(:rules) { class_double('Rules').as_stubbed_const(transfer_nested_constants: true) }

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
    context 'when pawn is white' do
      context 'when pawn is capturing' do
        let(:row) { 2 }
        let(:column) { 4 }
        let(:left_capture) { 'e6xd7' }
        let(:right_capture) { 'e6xf7' }

        before do
          allow(white_pawn).to receive(:forward_moves).and_return([])
          allow(white_pawn).to receive(:en_passant_captures).and_return([])
          allow(white_pawn).to receive(:promotions).and_return([])
          allow(board).to receive(:piece)
        end

        context 'when source position does not exist' do
          before do
            allow(rules).to receive(:row_column_to_position).and_return(nil)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when enemy piece is in left diagonal position' do
          before do
            allow(white_pawn).to receive(:enemy?).and_return(true, false)
          end

          it 'returns the capture' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([left_capture])
          end
        end

        context 'when enemy piece is in right diagonal position' do
          before do
            allow(white_pawn).to receive(:enemy?).and_return(false, true)
          end

          it 'returns the capture' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([right_capture])
          end
        end

        context 'when enemy piece is in both diagonal positions' do
          before do
            allow(white_pawn).to receive(:enemy?).and_return(true, true)
          end

          it 'returns both captures' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([left_capture, right_capture])
          end
        end
      end

      context 'when pawn is moving' do
        before do
          allow(white_pawn).to receive(:regular_captures).and_return([])
          allow(white_pawn).to receive(:en_passant_captures).and_return([])
          allow(white_pawn).to receive(:promotions).and_return([])
        end

        context 'when source position does not exist' do
          before do
            allow(rules).to receive(:row_column_to_position).and_return(nil)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, -1, -1)
            expect(result).to eq([])
          end
        end

        context 'when pawn is on starting row' do
          let(:row) { 6 }
          let(:column) { 0 }
          let(:move1) { 'a2-a3' }
          let(:move2) { 'a2-a4' }

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
          let(:column) { 0 }
          let(:move1) { 'a4-a5' }

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
    end

    context 'when pawn is black' do
      context 'when pawn is capturing' do
        let(:row) { 2 }
        let(:column) { 4 }
        let(:left_capture) { 'e6xd5' }
        let(:right_capture) { 'e6xf5' }

        before do
          allow(black_pawn).to receive(:forward_moves).and_return([])
          allow(black_pawn).to receive(:en_passant_captures).and_return([])
          allow(black_pawn).to receive(:promotions).and_return([])
          allow(board).to receive(:piece)
        end

        context 'when source position does not exist' do
          before do
            allow(rules).to receive(:row_column_to_position).and_return(nil)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when enemy piece is in left diagonal position' do
          before do
            allow(black_pawn).to receive(:enemy?).and_return(true, false)
          end

          it 'returns the capture' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([left_capture])
          end
        end

        context 'when enemy piece is in right diagonal position' do
          before do
            allow(black_pawn).to receive(:enemy?).and_return(false, true)
          end

          it 'returns the capture' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([right_capture])
          end
        end

        context 'when enemy piece is in both diagonal positions' do
          before do
            allow(black_pawn).to receive(:enemy?).and_return(true, true)
          end

          it 'returns both captures' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([left_capture, right_capture])
          end
        end
      end

      context 'when pawn is moving' do
        before do
          allow(black_pawn).to receive(:regular_captures).and_return([])
          allow(black_pawn).to receive(:en_passant_captures).and_return([])
          allow(black_pawn).to receive(:promotions).and_return([])
        end

        context 'when source position does not exist' do
          before do
            allow(rules).to receive(:row_column_to_position).and_return(nil)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, -1, -1)
            expect(result).to eq([])
          end
        end

        context 'when pawn is on starting row' do
          let(:row) { 1 }
          let(:column) { 0 }
          let(:move1) { 'a7-a6' }
          let(:move2) { 'a7-a5' }

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
          let(:column) { 0 }
          let(:move1) { 'a4-a3' }

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

  describe '#enemy?' do
    context 'when pawn is white' do
      context 'when other piece is nil' do
        it 'returns false' do
          expect(white_pawn.enemy?(nil)).to eq(false)
        end
      end

      context 'when other piece is white' do
        it 'returns false' do
          expect(white_pawn.enemy?(white_pawn)).to eq(false)
        end
      end

      context 'when other piece is black' do
        it 'returns true' do
          expect(white_pawn.enemy?(black_pawn)).to eq(true)
        end
      end
    end

    context 'when pawn is black' do
      context 'when other piece is nil' do
        it 'returns false' do
          expect(black_pawn.enemy?(nil)).to eq(false)
        end
      end

      context 'when other piece is white' do
        it 'returns true' do
          expect(black_pawn.enemy?(white_pawn)).to eq(true)
        end
      end

      context 'when other piece is black' do
        it 'returns false' do
          expect(black_pawn.enemy?(black_pawn)).to eq(false)
        end
      end
    end
  end
end

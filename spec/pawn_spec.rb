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
    context 'when pawn is white' do
      context 'when source position is nil' do
        it 'returns empty array' do
          expect(white_pawn.available_moves(board, -1, -1)).to eq([])
        end
      end

      context 'when source position is NOT nil' do
        let(:row) { 2 }
        let(:column) { 3 }

        before do
          allow(white_pawn).to receive(:forward_moves).and_return([])
          allow(white_pawn).to receive(:regular_captures).and_return([])
          allow(white_pawn).to receive(:en_passant_captures).and_return([])
        end

        it 'calls #forward_moves once' do
          expect(white_pawn).to receive(:forward_moves).once
          white_pawn.available_moves(board, row, column)
        end

        it 'calls #regular_captures once' do
          expect(white_pawn).to receive(:regular_captures).once
          white_pawn.available_moves(board, row, column)
        end

        it 'calls #en_passant_captures once' do
          expect(white_pawn).to receive(:en_passant_captures).once
          white_pawn.available_moves(board, row, column)
        end
      end

      context 'when pawn is capturing en passant' do
        let(:row) { 3 }
        let(:column) { 3 }
        let(:last_move_left) { 'c7-c5' }
        let(:last_move_right) { 'e7-e5' }
        let(:left_capture) { 'd5xc6ep' }
        let(:right_capture) { 'd5xe6ep' }

        before do
          allow(white_pawn).to receive(:forward_moves).and_return([])
          allow(white_pawn).to receive(:regular_captures).and_return([])
        end

        context 'when source position does not exist' do
          before do
            allow(board).to receive(:last_move)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, -1, -1)
            expect(result).to eq([])
          end
        end

        context 'when target position does not exist' do
          before do
            allow(board).to receive(:last_move)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when target position on board is not empty' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(false)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when landing piece is not enemy' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(white_pawn).to receive(:enemy?).and_return(false)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when last move landing position is not adjacent to current position' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(white_pawn).to receive(:enemy?).and_return(true)
            allow(white_pawn).to receive(:adjacent?).and_return(false)
          end

          it 'returns empty array' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when last move landing position is left adjacent to current position' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(white_pawn).to receive(:enemy?).and_return(true)
            allow(white_pawn).to receive(:adjacent?).and_return(true)
          end

          it 'returns left diagonal capture en passant' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([left_capture])
          end
        end

        context 'when last move landing position is right adjacent to current position' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_right)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(white_pawn).to receive(:enemy?).and_return(true)
            allow(white_pawn).to receive(:adjacent?).and_return(true)
          end

          it 'returns left diagonal capture en passant' do
            result = white_pawn.available_moves(board, row, column)
            expect(result).to eq([right_capture])
          end
        end
      end

      context 'when pawn is capturing' do
        let(:row) { 2 }
        let(:column) { 4 }
        let(:left_capture) { 'e6xd7' }
        let(:right_capture) { 'e6xf7' }

        before do
          allow(white_pawn).to receive(:forward_moves).and_return([])
          allow(white_pawn).to receive(:en_passant_captures).and_return([])
          allow(board).to receive(:piece)
        end

        context 'when source position does not exist' do
          it 'returns empty array' do
            result = white_pawn.available_moves(board, -1, -1)
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
        end

        context 'when source position does not exist' do
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

        context 'when pawn is one position away from promotion position' do
          let(:row) { 1 }
          let(:column) { 4 }

          context 'when promotion position is not empty' do
            before do
              allow(board).to receive(:empty?).and_return(false)
            end

            it 'returns empty array' do
              result = white_pawn.available_moves(board, row, column)
              expect(result).to eq([])
            end
          end

          context 'when promotion position is empty' do
            let(:promotion_move) { 'e7-e8=' }
            before do
              allow(board).to receive(:empty?).and_return(true)
            end

            it 'returns promotion move' do
              result = white_pawn.available_moves(board, row, column)
              expect(result).to eq([promotion_move])
            end
          end
        end
      end
    end

    context 'when pawn is black' do
      context 'when source position is nil' do
        it 'returns empty array' do
          expect(black_pawn.available_moves(board, -1, -1)).to eq([])
        end
      end

      context 'when source position is NOT nil' do
        let(:row) { 2 }
        let(:column) { 3 }

        before do
          allow(black_pawn).to receive(:forward_moves).and_return([])
          allow(black_pawn).to receive(:regular_captures).and_return([])
          allow(black_pawn).to receive(:en_passant_captures).and_return([])
        end

        it 'calls #forward_moves once' do
          expect(black_pawn).to receive(:forward_moves).once
          black_pawn.available_moves(board, row, column)
        end

        it 'calls #regular_captures once' do
          expect(black_pawn).to receive(:regular_captures).once
          black_pawn.available_moves(board, row, column)
        end

        it 'calls #en_passant_captures once' do
          expect(black_pawn).to receive(:en_passant_captures).once
          black_pawn.available_moves(board, row, column)
        end
      end

      context 'when pawn is capturing en passant' do
        let(:row) { 4 }
        let(:column) { 3 }
        let(:last_move_left) { 'c2-c4' }
        let(:last_move_right) { 'e2-e4' }
        let(:left_capture) { 'd4xc3ep' }
        let(:right_capture) { 'd4xe3ep' }

        before do
          allow(black_pawn).to receive(:forward_moves).and_return([])
          allow(black_pawn).to receive(:regular_captures).and_return([])
        end

        context 'when source position does not exist' do
          before do
            allow(board).to receive(:last_move)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, -1, -1)
            expect(result).to eq([])
          end
        end

        context 'when target position does not exist' do
          before do
            allow(board).to receive(:last_move)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when target position on board is not empty' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(false)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when landing piece is not enemy' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(black_pawn).to receive(:enemy?).and_return(false)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when last move landing position is not adjacent to current position' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(black_pawn).to receive(:enemy?).and_return(true)
            allow(black_pawn).to receive(:adjacent?).and_return(false)
          end

          it 'returns empty array' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([])
          end
        end

        context 'when last move landing position is left adjacent to current position' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_left)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(black_pawn).to receive(:enemy?).and_return(true)
            allow(black_pawn).to receive(:adjacent?).and_return(true)
          end

          it 'returns left diagonal capture en passant' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([left_capture])
          end
        end

        context 'when last move landing position is right adjacent to current position' do
          before do
            allow(board).to receive(:last_move).and_return(last_move_right)
            allow(board).to receive(:empty?).and_return(true)
            allow(board).to receive(:piece)
            allow(black_pawn).to receive(:enemy?).and_return(true)
            allow(black_pawn).to receive(:adjacent?).and_return(true)
          end

          it 'returns left diagonal capture en passant' do
            result = black_pawn.available_moves(board, row, column)
            expect(result).to eq([right_capture])
          end
        end
      end

      context 'when pawn is capturing' do
        let(:row) { 2 }
        let(:column) { 4 }
        let(:left_capture) { 'e6xd5' }
        let(:right_capture) { 'e6xf5' }

        before do
          allow(black_pawn).to receive(:forward_moves).and_return([])
          allow(black_pawn).to receive(:en_passant_captures).and_return([])
          allow(board).to receive(:piece)
        end

        context 'when source position does not exist' do
          it 'returns empty array' do
            result = black_pawn.available_moves(board, -1, -1)
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
        end

        context 'when source position does not exist' do
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

        context 'when pawn is one position away from promotion position' do
          let(:row) { 6 }
          let(:column) { 4 }

          context 'when promotion position is not empty' do
            before do
              allow(board).to receive(:empty?).and_return(false)
            end

            it 'returns empty array' do
              result = black_pawn.available_moves(board, row, column)
              expect(result).to eq([])
            end
          end

          context 'when promotion position is empty' do
            let(:promotion_move) { 'e2-e1=' }
            before do
              allow(board).to receive(:empty?).and_return(true)
            end

            it 'returns promotion move' do
              result = black_pawn.available_moves(board, row, column)
              expect(result).to eq([promotion_move])
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

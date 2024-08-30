# frozen_string_literal: true

require_relative '../lib/rules'

RSpec.describe Rules do
  it 'returns 8 for number of ranks' do
    expect(described_class::NUM_RANKS).to eq(8)
  end

  it 'returns 8 for number of files' do
    expect(described_class::NUM_FILES).to eq(8)
  end

  it 'returns light white symbol for light square color' do
    expect(described_class::LIGHT_SQUARE_COLOR).to eq(:light_white)
  end

  it 'returns white symbol for dark square color' do
    expect(described_class::DARK_SQUARE_COLOR).to eq(:white)
  end

  it 'returns array of file labels' do
    expect(described_class::FILES).to eq(%w[a b c d e f g h])
  end

  it 'returns 6 as start row for white pawns' do
    expect(described_class::WHITE_PAWNS_START_ROW).to eq(6)
  end

  it 'returns 1 as start row for black pawns' do
    expect(described_class::BLACK_PAWNS_START_ROW).to eq(1)
  end

  it 'returns gray symbol for white colored pieces' do
    expect(described_class::WHITE).to eq(:gray)
  end

  it 'returns black symbol for black colored pieces' do
    expect(described_class::BLACK).to eq(:black)
  end

  it 'returns map of ranks to rows' do
    expected = {
      '8' => 0,
      '7' => 1,
      '6' => 2,
      '5' => 3,
      '4' => 4,
      '3' => 5,
      '2' => 6,
      '1' => 7
    }

    expect(described_class::RANK_TO_ROW_MAP).to eq(expected)
  end

  it 'returns map of files to columns' do
    expected = {
      'a' => 0,
      'b' => 1,
      'c' => 2,
      'd' => 3,
      'e' => 4,
      'f' => 5,
      'g' => 6,
      'h' => 7
    }

    expect(described_class::FILE_TO_COLUMN_MAP).to eq(expected)
  end

  describe '::out_of_bounds?' do
    context 'when position is not length 2' do
      let(:position) { 'aaa' }
      it 'returns true' do
        expect(described_class.out_of_bounds?(position)).to eq(true)
      end
    end

    context 'when file does not exist' do
      let(:position) { 'z1' }
      it 'returns true' do
        expect(described_class.out_of_bounds?(position)).to eq(true)
      end
    end

    context 'when rank does not exist' do
      let(:position) { 'a0' }
      it 'returns true' do
        expect(described_class.out_of_bounds?(position)).to eq(true)
      end
    end

    context 'when position exists' do
      let(:position) { 'a3' }
      it 'returns false' do
        expect(described_class.out_of_bounds?(position)).to eq(false)
      end
    end
  end

  describe '::position_to_row_column' do
    context 'when position is not length 2' do
      let(:position) { 'aaa' }

      it 'returns nil' do
        expect(described_class.position_to_row_column(position)).to be_nil
      end
    end

    context 'when file to column mapping does not exist' do
      let(:position) { 'z1' }

      it 'returns nil' do
        expect(described_class.position_to_row_column(position)).to be_nil
      end
    end

    context 'when rank to row mapping does not exist' do
      let(:position) { 'a0' }

      it 'returns nil' do
        expect(described_class.position_to_row_column(position)).to be_nil
      end
    end

    context 'when position matches existing file and rank mappings' do
      let(:position) { 'b3' }
      let(:expected) { [5, 1] }

      it 'returns a corresponding [row, column] array' do
        expect(described_class.position_to_row_column(position)).to eq(expected)
      end
    end
  end
end

require 'rspec_structure_matcher'

describe 'have_structure' do
  let(:expected_structure) {
    {
      'foo' => String,
      'bar' => String
    }
  }

  context 'when there are missing keys' do
    let(:structure) {
      {
        'foo' => 'baz'
      }
    }

    it 'raises the correct error' do
      expect {
        expect(structure).to have_structure(expected_structure)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /missing or invalid keys: bar/)
    end
  end

  context 'when there are invalid keys' do
    let(:structure) {
      {
        'foo' => 1,
        'bar' => 'baz'
      }
    }

    it 'raises the correct error' do
      expect {
        expect(structure).to have_structure(expected_structure)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /missing or invalid keys: foo/)
    end
  end

  context 'when there are no missing keys' do
    let(:structure) {
      {
        'foo' => 'baz',
        'bar' => 'baz'
      }
    }

    it 'raise no error' do
      expect {
        expect(structure).to have_structure(expected_structure)
      }.not_to raise_error
    end
  end

  context 'when there are symbol keys' do
    let(:structure) {
      {
        :foo => 'baz',
        'bar' => 'baz'
      }
    }

    it 'raise no error' do
      expect {
        expect(structure).to have_structure(expected_structure)
      }.not_to raise_error
    end
  end
end

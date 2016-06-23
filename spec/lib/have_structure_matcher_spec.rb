require 'spec_helper'
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
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /-"bar" => String/)
    end
  end

  context 'when there too many keys' do
    let(:structure) {
      {
        'foo' => 'baz',
        'bar' => 'baz',
        'bam' => 'baz'
      }
    }

    it 'raises the correct error' do
      expect {
        expect(structure).to have_structure(expected_structure)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /\+"bam" => "baz"/)
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
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /-"foo" => String/)
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

    it 'fails validation' do
      expect {
        expect(structure).to have_structure(expected_structure)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /-"foo" => String/)
    end
  end

  context 'matching exact values' do
    let(:structure) do
      {
        'foo' => 1,
        'bar' => 'baz'
      }
    end

    context 'with correct values' do
      let(:expected_structure) do
        {
          'foo' => 1,
          'bar' => 'baz'
        }
      end

      it 'raise no error' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.not_to raise_error
      end
    end

    context 'with incorrect values' do
      let(:expected_structure) do
        {
          'foo' => 2,
          'bar' => 'baz'
        }
      end

      it 'fails validation' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /-"foo" => 2/)
      end
    end
  end

  context 'matching with procs' do
    let(:test_lambda) { ->(actual_value) { actual_value == 'baz' } }

    let(:expected_structure) do
      {
        'foo' => test_lambda
      }
    end

    context 'correct value' do
      let(:structure) { {'foo' => 'baz'} }

      it 'raise no error' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.not_to raise_error
      end
    end

    context 'incorrect value' do
      let(:structure) { {'foo' => 100} }

      it 'fails validation' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /\+"foo" => 100/)
      end
    end
  end

  context "matching with 'optionally' helper method" do
    let(:expected_structure) do
      {
        'foo' => optionally(2)
      }
    end

    context 'correct value' do
      let(:structure) { {'foo' => 2} }

      it 'raise no error' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.not_to raise_error
      end
    end

    context 'null value' do
      let(:structure) { {'foo' => nil} }

      it 'raise no error' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.not_to raise_error
      end
    end
  end

  context "with nested structure" do
    let(:expected_structure) do
      {
        'foo' => 1,
        'bar' => {
          'baz' => String
        }
      }
    end

    context "matches correctly" do
      let(:structure) do
        {
          'foo' => 1,
          'bar' => {
            'baz' => 'hello'
          }
        }
      end

      it 'passes validation' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.not_to raise_error
      end
    end

    context "mis-matched nesting" do
      let(:structure) do
        {
          'foo' => 1,
          'bar' => 'a'
        }
      end

      it 'fails validation' do
        expect {
          expect(structure).to have_structure(expected_structure)
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /\+"bar" => "a"/)
      end
    end

  end
end

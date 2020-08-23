# frozen_string_literal: true

RSpec.describe Parser::LogfileValidator do
  subject { described_class.new(file) }

  context 'when file has valid entries' do
    let(:file) { File.open('./spec/fixtures/webserver.log') }

    it 'returns true and there is no errors' do
      expect(subject.valid?).to eq true
      expect(subject.errors).to be_empty
    end
  end

  context 'when file has invalid entries' do
    let(:file) { File.open('./spec/fixtures/webserver.invalid.log') }
    let(:expected_errors) do
      ['invalid entry on line 1: invalid page, invalid address',
       'invalid entry on line 3: invalid address']
    end

    it 'returns false and populates errors' do
      expect(subject.valid?).to eq false
      expect(subject.errors).to match_array expected_errors
      expect(subject.formated_errors).to eq expected_errors.join("\n")
    end
  end
end

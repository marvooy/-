# frozen_string_literal: true

RSpec.describe Parser::EntryValidator do
  subject { described_class.new(entry) }

  context 'when entry is valid' do
    let(:entry) { '/help_page/1 111.111.111.111' }
    it 'returns true and there is no errors' do
      expect(subject.valid?).to eq true
      expect(subject.errors).to be_empty
    end
  end

  context 'when entry is invalid' do
    [
      '/about 235 313 352 950',
      '',
      '/help_page/1 /home 111.111.111.111'
    ].each_with_index do |entry, i|
      context "when entry doesnt split into page and address ##{i + 1}" do
        let(:entry) { entry }
        it 'returns false and populates errors' do
          expect(subject.valid?).to eq false
          expect(subject.errors).to include 'unable to extract page and address'
        end
      end
    end

    [
      '/about\ 111.111.111.111',
      '/about/ 111.111.111.111',
      'about   111.111.111.111',
      '//about 111.111.111.111',
      '/ABOUT 111.111.111.111'
    ].each_with_index do |entry, i|
      context "when entry has invalid page ##{i + 1} " do
        let(:entry) { entry }
        it 'returns false and populates errors' do
          expect(subject.valid?).to eq false
          expect(subject.errors).to include 'invalid page'
        end
      end
    end

    [
      '/about 1111.111.111.111',
      '/about 111.111.111.1111',
      '/about 111.111.111.11a',
      '/about 111.111.111'
    ].each_with_index do |entry, i|
      context "when entry has invalid address ##{i + 1} " do
        let(:entry) { entry }
        it 'returns false and populates errors' do
          expect(subject.valid?).to eq false
          expect(subject.errors).to include 'invalid address'
        end
      end
    end

    context 'when page and address are incorrect' do
      let(:entry) { 'INVALID_page INVALID_ADDRESS' }
      it 'returns false and populates errors with two messages' do
        expect(subject.valid?).to eq false
        expect(subject.errors).to include 'invalid address'
        expect(subject.errors).to include 'invalid page'
        expect(subject.formated_errors).to eq 'invalid page, invalid address'
      end
    end
  end
end

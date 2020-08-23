# frozen_string_literal: true

RSpec.describe Parser::ProcessedLogfile do
  let(:file) { File.open('./spec/fixtures/webserver.log') }

  subject { described_class.new(file) }

  describe '#most_views' do
    let(:expected_result) do
      [
        ['/about/2', 90],
        ['/contact', 89],
        ['/index', 82],
        ['/about', 81],
        ['/help_page/1', 80],
        ['/home', 78]
      ]
    end

    it 'returns pages with most view' do
      expect(subject.most_views).to eq expected_result
    end
  end

  describe '#most_unique_views' do
    let(:expected_result) do
      [
        ['/help_page/1', 23],
        ['/contact', 23],
        ['/home', 23],
        ['/index', 23],
        ['/about/2', 22],
        ['/about', 21]
      ]
    end

    it 'returns pages with most unique view' do
      expect(subject.most_unique_views).to eq expected_result
    end
  end
end

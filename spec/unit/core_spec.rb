# frozen_string_literal: true

RSpec.describe Parser::Core do
  subject { described_class.new(file) }

  let(:file) { instance_double(File) }
  let(:processed_logfile) { instance_double(Parser::ProcessedLogfile, most_views: most_views, most_unique_views: most_unique_views) }
  let(:validator) { instance_double(Parser::LogfileValidator, "valid?": valid?, formated_errors: formated_errors) }

  context 'when parsing valid logfile' do
    let(:formated_errors) { nil }
    let(:valid?) { true }

    let(:most_views) do
      [
        ['/about/2', 90],
        ['/contact', 89],
        ['/index', 82],
        ['/about', 81],
        ['/help_page/1', 80],
        ['/home', 78]
      ]
    end

    let(:most_unique_views) do
      [
        ['/help_page/1', 23],
        ['/contact', 23],
        ['/home', 23],
        ['/index', 23],
        ['/about/2', 22],
        ['/about', 21]
      ]
    end

    let(:expected_result) do
      <<~STRING.strip
        List of webpages with most views:
        /about/2 90 views
        /contact 89 views
        /index 82 views
        /about 81 views
        /help_page/1 80 views
        /home 78 views
        List of webpages with most unique views:
        /help_page/1 23 unique views
        /contact 23 unique views
        /home 23 unique views
        /index 23 unique views
        /about/2 22 unique views
        /about 21 unique views
      STRING
    end

    it 'returns formated results' do
      expect(Parser::LogfileValidator).to receive(:new).with(file).and_return(validator)
      expect(Parser::ProcessedLogfile).to receive(:new).with(file).and_return(processed_logfile)
      expect(subject.call).to eq expected_result
    end
  end

  context 'when parsing invalid logfile' do
    let(:formated_errors) { 'ERROR' }
    let(:valid?) { false }

    it 'returns formated errors' do
      expect(Parser::LogfileValidator).to receive(:new).with(file).and_return(validator)
      expect(Parser::ProcessedLogfile).not_to receive(:new).with(file)

      expect(subject.call).to eq formated_errors
    end
  end
end

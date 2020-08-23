# frozen_string_literal: true

RSpec.describe Parser::CLI do
  subject { described_class.new(args) }
  let(:args) { [file_path] }

  context 'when file exists' do
    context 'and its valid' do
      let(:file_path) { 'spec/fixtures/webserver.log' }
      let(:expected_result) do
        <<~STRING
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

      it 'gets parsed and result is printed' do
        expect { subject.call }.to output(expected_result).to_stdout
      end
    end

    context 'and its invalid' do
      let(:file_path) { 'spec/fixtures/webserver.invalid.log' }
      let(:expected_result) do
        "invalid entry on line 1: invalid page, invalid address\n" \
        "invalid entry on line 3: invalid address\n"
      end

      it 'gets validated and errors are printed' do
        expect { subject.call }.to output(expected_result).to_stdout
      end
    end
  end
end

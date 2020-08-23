# frozen_string_literal: true

RSpec.describe Parser::CLI do
  subject { described_class.new(args) }

  context 'when existing file path is pased' do
    let(:existing_file) { './spec/fixtures/webserver.log' }
    let(:parser) { instance_double(Parser::Core, call: :parser_result) }
    let(:args) { [existing_file] }

    it 'creates parser with opened file and calls it' do
      expect(File).to receive(:open).with(existing_file).and_return(:opened_file)
      expect(Parser::Core).to receive(:new).with(:opened_file).and_return(parser)

      expect(subject.call).to eq(:parser_result)
    end
  end

  context "when '--help' argument is passed" do
    let(:args) { ['--help'] }
    let(:filename) { './path/filename' }
    it 'prints help message' do
      expect { subject.call }.to output("Usage: parser ./path/to/file.log\n").to_stdout
    end
  end

  context 'when there is no arguments' do
    let(:args) { [] }
    it 'prints error message and exits' do
      expect { subject.call }
        .to output("You need to specify filepath! Use --help for usage example\n").to_stderr
        .and raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
    end
  end

  context 'when there is too many arguments' do
    let(:args) { %w[one two] }
    it 'prints error message and exits' do
      expect { subject.call }
        .to output("Too many arguements! Use --help for usage example\n").to_stderr
        .and raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
    end
  end

  context 'when nonexisting file path is passed' do
    let(:args) { ['./spec/fixtures/non_existing.log'] }
    let(:filename) { './path/filename' }
    it 'prints error message and exits' do
      expect { subject.call }
        .to output("File doesn't exist! Check if the path you passed is correct\n").to_stderr
        .and raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
    end
  end
end

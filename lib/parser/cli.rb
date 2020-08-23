# frozen_string_literal: true

module Parser
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def call
      return unless valid_arguments?

      handle_arguments
    end

    private

    def handle_arguments
      help? ? display_help_message : display_parser_results
    end

    def valid_arguments?
      if @argv.size.zero?
        warn 'You need to specify filepath! Use --help for usage example'
        exit(-1)
      elsif @argv.size >= 2
        warn 'Too many arguements! Use --help for usage example'
        exit(-1)
      elsif help?
        true
      elsif !File.exist?(argument)
        warn "File doesn't exist! Check if the path you passed is correct"
        exit(-1)
      else
        true
      end
    end

    def argument
      @argument ||= @argv.first
    end

    def help?
      @help ||= %w[--help -h].include? argument
    end

    def display_help_message
      puts 'Usage: parser ./path/to/file.log'
    end

    def display_parser_results
      file = File.open(argument)
      puts Parser::Core.new(file).call
    end
  end
end

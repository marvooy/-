# frozen_string_literal: true

module Parser
  class LogfileValidator
    attr_reader :errors, :logfile

    def initialize(logfile)
      logfile.rewind
      @logfile = logfile
      @errors = []
    end

    def valid?
      validate

      @errors.empty?
    end

    def validate
      @logfile.each_with_index do |line, index|
        validator = EntryValidator.new(line)

        @errors << "invalid entry on line #{index + 1}: #{validator.formated_errors}" unless validator.valid?
      end
    end

    def formated_errors
      @errors.join("\n")
    end
  end
end

# frozen_string_literal: true

module Parser
  class Core
    MOST_VIEWS_MESSAGE = 'List of webpages with most views:'
    MOST_UNIQUE_VIEWS_MESSAGE = 'List of webpages with most unique views:'

    attr_accessor :logfile, :result

    def initialize(logfile)
      @logfile = logfile
      @result = []
    end

    def call
      return validator.formated_errors unless valid_logfile?

      get_most_views
      get_most_unique_views

      @result.join("\n")
    end

    private

    def valid_logfile?
      validator.valid?
    end

    def validator
      @validator ||= LogfileValidator.new(@logfile)
    end

    def processed_logfile
      @processed_logfile ||= ProcessedLogfile.new(@logfile)
    end

    def get_most_views
      @result << MOST_VIEWS_MESSAGE
      format_result(processed_logfile.most_views, 'views')
    end

    def get_most_unique_views
      @result << MOST_UNIQUE_VIEWS_MESSAGE
      format_result(processed_logfile.most_unique_views, 'unique views')
    end

    def format_result(views_statistics, message)
      views_statistics.each do |statistic|
        page, count = statistic
        @result << "#{page} #{count} #{message}"
      end
    end
  end
end

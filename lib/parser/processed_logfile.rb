# frozen_string_literal: true

module Parser
  class ProcessedLogfile
    def initialize(logfile)
      logfile.rewind
      @logfile = logfile
      @views = Hash.new { |h, k| h[k] = [] }

      gather_views_per_page
    end

    def most_views
      sort_desc(views_count_dictionary)
    end

    def most_unique_views
      sort_desc(unique_views_count_dictionary)
    end

    private

    def gather_views_per_page
      @logfile.each do |line|
        page, address = line.split(' ')
        @views[page] << address
      end

      @views
    end

    def sort_desc(hash)
      hash.sort_by { |_k, v| -v }
    end

    def views_count_dictionary
      @views.transform_values(&:count)
    end

    def unique_views_count_dictionary
      @views.transform_values(&:uniq).transform_values(&:count)
    end
  end
end

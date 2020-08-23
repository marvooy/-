# frozen_string_literal: true

module Parser
  class EntryValidator
    VALID_PAGE_REGEX = %r{^(/[0-9a-z_]+)+$}.freeze
    VALID_ADDRESS_REGEX = /^((\d{1,3}\.){3}\d{1,3})$/.freeze

    EXTRACT_ERROR = 'unable to extract page and address'
    PAGE_ERROR = 'invalid page'
    ADDRESS_ERROR = 'invalid address'

    attr_reader :errors, :entry, :address, :page

    def initialize(entry)
      @entry = entry
      @errors = []
    end

    def valid?
      validate

      @errors.empty?
    end

    def formated_errors
      @errors.join(', ')
    end

    private

    def validate
      unless splits_in_half?
        @errors << EXTRACT_ERROR
        return
      end

      extract_page_and_address
      validate_page
      validate_address
    end

    def splits_in_half?
      @entry.split(' ').size == 2
    end

    def extract_page_and_address
      @page, @adress = @entry.split(' ')
    end

    def validate_page
      @errors << PAGE_ERROR unless VALID_PAGE_REGEX.match?(@page)
    end

    def validate_address
      @errors << ADDRESS_ERROR unless VALID_ADDRESS_REGEX.match?(@adress)
    end
  end
end

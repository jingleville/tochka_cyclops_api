# frozen_string_literal: true

module TochkaCyclopsApi
  # Displays the result of request
  class Result
    attr_reader :success, :data, :error_message

    def self.create(success, data = nil, error_message = nil)
      @success = success
      @data = data
      @error_message = error_message

      display_result
    end

    def self.success(data)
      Result.create(true, data)
    end

    def self.failure(error_message)
      Result.create(false, nil, error_message)
    end

    private

    def self.display_result
      {
        success: @success,
        data: @data || @error_message
      }
    end
  end
end

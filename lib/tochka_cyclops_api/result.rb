# frozen_string_literal: true

# откуда сюда можно попасть
# data_processor
#   невалидые данные
#   нет такой схемы
# request
#   400 ошибка
#   500 ошибка
# response
#   result
#   error

# {
#   result: 'Success' ('InternalError', 'ApiError')
#   result_data: {
#     ...
#   }
# }

module TochkaCyclopsApi
  # Displays the result of request
  class Result
    attr_reader :success, :data, :error_message

    def initialize(success, data = nil, error_message = nil)
      @success = success
      @data = data
      @error_message = error_message

      display_result
    end

    def self.success(data)
      Result.new(true, data)
    end

    def self.failure(error_message)
      Result.new(false, nil, error_message)
    end

    private

    def display_result
          {
            success: @success,
            data: @data || @error_message
          }
        end
  end
end

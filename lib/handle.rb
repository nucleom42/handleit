# frozen_string_literal: true

class Handle
  NotValidError = Class.new(StandardError)

  class << self
    def it(options = {}, &block)
      new.it(options, &block)
    end
  end

  def it(options)
    validate(options)

    @result = OpenStruct.new return: yield, success: true, error: nil
    self
  rescue StandardError => e
    error_handler(e)
  end

  def with
    @result.return = yield(@result.return, **options = {}) if success?
    self
  rescue StandardError => e
    error_handler(e)
  end

  def on_fail
    yield(@result.error, **options = {}) unless success?
    self
  end

  def result
    @result.return
  end

  def success?
    @result.success == true
  end

  def error
    @result.error
  end

  private

  def error_handler(err)
    @result = OpenStruct.new return: nil, success: false, error: err
    self
  end

  def validate(options)
    condition = options[:when]
    condition_error = options[:error] || 'Not Valid!'
    good_to_go = condition&.respond_to?(:call) ? condition&.call : true
    raise NotValidError, condition_error unless good_to_go
  end
end

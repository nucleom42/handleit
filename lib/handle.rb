# frozen_string_literal: true

class Handle
  class << self
    def it(&block)
      new.it(&block)
    end
  end

  def it
    @result = OpenStruct.new return: yield, success: true, error: nil
    self
  rescue StandardError => e
    @result = OpenStruct.new return: nil, success: false, error: e
    self
  end

  def with
    @result.return = yield(@result.return, **options = {}) if success?
    self
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
end

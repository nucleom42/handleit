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
    @returns_pool = []
    self
  rescue StandardError => e
    error_handler(e)
  end

  def >(args={}, &block)
    with(args, &block)
  end

  def <=
    result
  end

  def e(&block)
    on_fail(&block)
  end

  def with(args={}, &block)
    args = args.slice(:on_fail)

    if success?
      @returns_pool << block.call(@result.return, **options = {})
      @result.return = @returns_pool.last
    end
    self
  rescue StandardError => e
    if args[:on_fail] == :rollback
      @result.return = @returns_pool.last
      self
    else
      error_handler(e)
    end
  end

  def on_fail(&block)
    block.call(@result.error, **options = {}) unless success?
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
    condition = options[:when].nil? || options[:when]
    condition_error = options[:error] || options[:not_valid_error] || 'Not Valid!'
    good_to_go = condition&.respond_to?(:call) ? condition&.call : condition

    raise NotValidError, condition_error unless good_to_go
  end
end

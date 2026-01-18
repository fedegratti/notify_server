# frozen_string_literal: true

# It allows use to invoke a service with a bang!,
# raising exceptions if they occur, or without one,
# which will always return a simple and well-defined
# result object which can be checked for success for failure,
# as well as a payload and or error if we need to process the result further.

# This implementation also provides some syntactic sugar for invoking services
# via a class method instead of the slightly longer way of calling an instance method
# on an actual object, i.e. SomeService.call(...)instead of SomeService.new(...).call.

# Speaking of the non-bang version, its primary use is to handle commonly
# encountered failures that are not really exceptions.
# Using exceptions for flow control is an anti-pattern.

class ApplicationService
  Response = Struct.new(:success?, :payload, :error) do
    def failure?
      !success?
    end
  end

  def initialize(propagate = true) # rubocop:disable Style/OptionalBooleanParameter
    @propagate = propagate
  end

  def self.call(...)
    service = new(false)
    service.call(...)
  rescue StandardError => e
    service.failure(e)
  end

  def self.call!(...)
    new(true).call(...)
  end

  def success(payload = nil)
    Response.new(true, payload)
  end

  def failure(exception, options = {})
    raise exception if @propagate

    Response.new(false, nil, exception)
  end
end

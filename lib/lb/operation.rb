# frozen_string_literal: true

require 'dry-configurable'
require 'dry-equalizer'

require 'lb/operation/version'
require 'lb/operation/log'

# LB namespace
module LB
  # Base class for operations
  class Operation
    include Dry::Equalizer(:config)
    extend Dry::Configurable
    include LB::Operation::Log

    setting :name

    attr_reader :config

    # Retrieves the operation name.
    #
    # @return [Symbol]
    def self.operation_name
      config.name
    end

    # Executes the operation.
    #
    # @return [self]
    def call
      raise NotImplementedError, 'Override Operation#call(*args)!'
    end

    # Executes the operation with given arguments. Returns result or value of
    # result if result responds to :value.
    #
    # @param [Array] args
    # @return [Object]
    def value(*args)
      result = call(*args)
      result.respond_to?(:value) ? result.value : result
    end

    # Handles exception if given: Logs message and backtrace as :error.
    #
    # @param [Hash] error
    # @return [self]
    def handle_exception(error)
      return self unless error.key?(:exception)
      exception = error.fetch(:exception)
      log :error, exception.message
      log :error, exception.backtrace.inspect

      self
    end
  end
end

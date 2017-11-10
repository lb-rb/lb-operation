# frozen_string_literal: true

module LB
  class Operation
    # Helper for logging
    module Log
      # Logger class interface
      module ClassInterface
        attr_reader :logger

        # Sets the logger.
        #
        # @param [Object] logger
        # @return [self]
        def with_logger(logger)
          @logger = logger
          self
        end
      end

      # Extends base class with class interface.
      #
      # @param [Class] base
      # @return [Object]
      def self.included(base)
        base.extend ClassInterface
      end

      # Retrieves the logger.
      #
      # @return [Object]
      def logger
        result = self.class.logger
        if result.nil?
          raise ArgumentError,
                'No logger availible: Please set logger via '\
                'LB::Operation::Log[logger] or '\
                'LB::Operation::Log.with_logger(logger)'
        end
        result
      end

      # Calls given logger method with given arguments.
      #
      # @param [Symbol] method
      # @param [Array] args
      # @return [Object]
      def log(method, *args)
        unless logger.respond_to?(method)
          raise ArgumentError, "Logger does not respond to :#{method}."
        end
        logger.public_send(method, *args)
      end
    end
  end
end

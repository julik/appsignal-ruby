# frozen_string_literal: true

require "logger"
require "set"

module Appsignal
  # Logger that flushes logs to the AppSignal logging service
  class Logger < ::Logger
    # Create a new logger instance
    #
    # @param group Name of the group for this logger.
    # @param level Log level to filter with
    # @return [void]
    def initialize(group, level = INFO)
      raise TypeError, "group must be a string" unless group.is_a? String
      @group = group
      @level = level
    end

    # We support the various methods in the Ruby
    # logger class by supplying this method.
    # @api private
    def add(severity, message = nil, group = nil)
      severity ||= UNKNOWN
      puts "LOG: #{message}"
      return true if severity < level
      group = @group if group.nil?
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          group = @group
        end
      end
      return if message.nil?
      severity_number = case severity
                        when DEBUG
                          2
                        when INFO
                          3
                        when WARN
                          5
                        when ERROR
                          6
                        when FATAL
                          7
                        else
                          0
                        end

      puts "LOG (#{severity_number}) (EXT): #{message}"
      Appsignal::Extension.log(
        group,
        severity_number,
        message,
        Appsignal::Utils::Data.generate({})
      )
    end
    alias log add

    # Log a debug level message
    # @param message Mesage to log
    # @param attributes Attributes to tag the log with
    # @return [void]
    def debug(message = nil, attributes = {})
      puts "DEBUG: #{message}"
      return if DEBUG < level
      message = yield if message.nil? && block_given?
      return if message.nil?
      puts "DEBUG (EXT): #{message}"
      Appsignal::Extension.log(
        @group,
        2,
        message,
        Appsignal::Utils::Data.generate(attributes)
      )
    end

    # Log an info level message
    # @param message Mesage to log
    # @param attributes Attributes to tag the log with
    # @return [void]
    def info(message = nil, attributes = {})
      puts "INFO: #{message}"
      return if INFO < level
      message = yield if message.nil? && block_given?
      return if message.nil?
      puts "INFO (EXT): #{message}"
      Appsignal::Extension.log(
        @group,
        3,
        message,
        Appsignal::Utils::Data.generate(attributes)
      )
    end

    # Log a warn level message
    # @param message Mesage to log
    # @param attributes Attributes to tag the log with
    # @return [void]
    def warn(message = nil, attributes = {})
      puts "WARN: #{message}"
      return if WARN < level
      message = yield if message.nil? && block_given?
      return if message.nil?
      puts "WARN (EXT): #{message}"
      Appsignal::Extension.log(
        @group,
        5,
        message,
        Appsignal::Utils::Data.generate(attributes)
      )
    end

    # Log an error level message
    # @param message Mesage to log
    # @param attributes Attributes to tag the log with
    # @return [void]
    def error(message = nil, attributes = {})
      puts "ERROR: #{message}"
      return if ERROR < level
      message = yield if message.nil? && block_given?
      return if message.nil?
      puts "ERROR (EXT): #{message}"
      Appsignal::Extension.log(
        @group,
        6,
        message,
        Appsignal::Utils::Data.generate(attributes)
      )
    end

    # Log a fatal level message
    # @param message Mesage to log
    # @param attributes Attributes to tag the log with
    # @return [void]
    def fatal(message = nil, attributes = {})
      puts "FATAL: #{message}"
      return if FATAL < level
      message = yield if message.nil? && block_given?
      return if message.nil?
      puts "FATAL (EXT): #{message}"
      Appsignal::Extension.log(
        @group,
        7,
        message,
        Appsignal::Utils::Data.generate(attributes)
      )
    end
  end
end

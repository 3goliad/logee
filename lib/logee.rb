require "time"
require "json"
require "logee/version"

module Logee
  class Logger
    def initialize(name:, context: {}, parent: nil, target: $stdout)
      @name = name
      @context = context
      @parent = parent
      @target = target
      @hostname = @parent.nil? ? `hostname`.strip : @parent.hostname
    end

    def context(ctx = nil)
      if ctx.nil?
        @context
      else
        @context.merge! ctx
      end
    end

    def msg(msg, context = {})
      JSON.dump(
        @context.merge(context.merge({
          msg: msg,
          time: Time.now.utc.iso8601(3),
          name: @name,
          hostname: @hostname,
          pid: Process.pid,
        })),
        @target
      )
    end

    def child(name, context = {})
      child_logger = Logee::Logger.
        new("#{@name}::#{name}", @context.merge(context))
      child_logger.set_instance_variable(:@parent, self)
      if block_given?
        yield child_logger
      else
        child_logger
      end
    end

    protected

    attr_reader :hostname
  end
end

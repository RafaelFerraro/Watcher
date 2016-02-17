require 'syslog/logger'

module Watcher
  module Logger
    module_function

    def log
      @log ||= Syslog::Logger.new 'Watcher'
      @log.formatter = proc do |severity, time, progname, msg|
        Thread.current[:correlation_id] ||= Time.now.to_f

        "[CID: #{Thread.current[:correlation_id]}]: #{msg}"
      end

      @log
    end

    def write(message)
      p message
    end

    %w{debug info warn error fatal}.each do |level|
      self.class.send(:define_method, level) { |message| self.log.send(level, message) }
    end

  end
end

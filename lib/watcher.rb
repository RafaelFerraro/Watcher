require 'daemons'
require 'ostruct'
require 'yaml'
require 'pdf-reader'
require './lib/watcher/listener.rb'
# require './lib/logger.rb'

# This class will initialize the daemonize application
module Watcher
  def self.config
    filename = File.expand_path(
      '../../config/config.yml', __FILE__
    )

    raise LoadError, "config file (#{filename}) not found",
    caller unless File.exists?(filename)

    yml       = YAML.load_file(filename)
    @config ||= OpenStruct.new(yml)
  end

  # get up a new ruby process, called watcher,
  # and start to listen the folder to get some pdf files
  def self.execute
    # Watcher::Logger.info("****** Starting Watcher *********")

    Daemons.run_proc('watcher') { Listener.listen }
  end
end



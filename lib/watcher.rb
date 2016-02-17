require 'daemons'
require 'ostruct'
require 'yaml'
require './lib/logger.rb'
require './lib/watcher/listener.rb'

module Watcher
  def self.config
    filename = File.expand_path(
      '../../config/config.yml', __FILE__
    )

    raise LoadError, "config file (#{filename}) not found", caller unless File.exists?(
      filename
    )

    yml       = YAML.load_file(filename)
    @config ||= OpenStruct.new(yml)
  end

  def self.execute
    Watcher::Logger.info("****** Starting Watcher *********")

    Daemons.run_proc('watcher') { Listener.listen }
  end
end



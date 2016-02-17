require 'listen'

module Watcher
  class Listener
    def self.listen
      folder = Watcher.config.folder
      listener = Listen.to(folder) do |modified, added, removed|
        Watcher::Logger.info("modified file #{modified}")
        Watcher::Logger.info("added file #{added}")
        Watcher::Logger.info("removed file #{removed}")
      end

      Watcher::Logger.info("Listening for files in #{folder}")
      listener.start

      sleep(100)
    end
  end
end
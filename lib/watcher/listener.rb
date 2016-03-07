module Watcher
  # this class listen to a directory for any pdf file that has into that
  class Listener
    def self.listen
      loop do
        run
        sleep(10)
      end
    end

    def self.run
      files.each { |file| exec(file) if FileManager.is_pdf?(file) }
    end

    def self.exec(file)
      # Watcher::Logger.info("A new pdf file was found - #{file}")
      tmp_file = FileManager.move_to_tmp(file)

      # create a pdf reader
      pdf = FileManager.create_pdf(tmp_file)

      pdf.pages.map { |page|  }
    end

    private

    def self.files
      Dir[Watcher.config.files].to_a
    end

  end
end
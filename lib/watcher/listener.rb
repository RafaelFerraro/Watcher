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
      files.each { |file| exec(file) if is_pdf?(file) }
    end

    def self.exec(file)
      # Watcher::Logger.info("A new pdf file was found - #{file}")
      pdf = PDF::Reader.new(file)

      pdf.pages.map { |page| page.text }
    end

    private

    def self.is_pdf?(file)
      File.extname(file) == ".pdf"
    end

    def self.files
      Dir[Watcher.config.files].to_a
    end

  end
end
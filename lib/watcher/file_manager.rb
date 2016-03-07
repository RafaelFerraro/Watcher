module Watcher
  class FileManager

    def self.move(from, to)
      dir = File.dirname(to)

      create_dir(dir) unless Dir.exists?(dir)

      FileUtils.mv(from, to)
    end

    def self.create_dir(dir)
      FileUtils.mkdir_p(dir)
    end

    def self.create_pdf(file)
      PDF::Reader.new(file)
    end

    def self.is_pdf?(file)
      File.extname(file) == ".pdf"
    end

    def self.move_to_tmp(file)
      tmp_file   = "#{Watcher.config.tmp_folder}/#{File.basename(file)}"

      move(file, tmp_file)

      tmp_file
    end

  end # FileManager
end # Watcher
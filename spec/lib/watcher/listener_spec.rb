require 'spec_helper'

describe Watcher::Listener do
  describe ".run" do
    context "when all files are pdf" do
      let(:first)  { File.expand_path("spec/support/files/first.pdf") }
      let(:second) { File.expand_path("spec/support/files/second.pdf") }

      before do
        FileUtils.touch(first); FileUtils.touch(second)
        allow(described_class).to receive(:files){ [first, second] }
      end

      after do
        FileUtils.remove_file(first); FileUtils.remove_file(second)
      end

      it 'execs exactly two times' do
        expect(described_class).to receive(:exec).twice
        described_class.run
      end
    end

    context "when any file isn't pdf" do
      let(:pdf_file) { File.expand_path("spec/support/files/pdf_file.pdf") }
      let(:non_pdf)  { File.expand_path("spec/support/files/non_pdf.txt") }

      before do
        FileUtils.touch(pdf_file); FileUtils.touch(non_pdf)
        allow(described_class).to receive(:files){ [pdf_file, non_pdf] }
      end

      after do
        FileUtils.remove_file(pdf_file); FileUtils.remove_file(non_pdf)
      end

      it 'execs just one time' do
        expect(described_class).to receive(:exec).once.with(pdf_file)
        described_class.run
      end
    end
  end # .run

  describe '.exec' do
    let(:first_page) { double("PDF::Reader::Page", text: 'Text within pdf file') }
    let(:pdf_reader) { double("PDF::Reader", pages: [first_page]) }

    it 'moves the file to tmp folder' do
      allow(Watcher::FileManager).to receive(:create_pdf){
        pdf_reader
      }

      expect(Watcher::FileManager).to receive(:move_to_tmp).with('argument file'){
        'tmp file'
      }
      Watcher::Listener.exec('argument file')
    end

    it 'creates a pdf reader to access your text/values' do
      allow(Watcher::FileManager).to receive(:move_to_tmp){
        'tmp file'
      }

      expect(Watcher::FileManager).to receive(:create_pdf).with(
        'tmp file'
      ){ pdf_reader }

      Watcher::Listener.exec('argument file')
    end
  end # .exec
end
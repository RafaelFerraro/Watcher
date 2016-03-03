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

    it 'creates a new pdf reader' do
      expect(PDF::Reader).to receive(:new).with('file_in_args'){ pdf_reader }
      described_class.exec('file_in_args')
    end

    it 'returns the text within page' do
      allow(PDF::Reader).to receive(:new){ pdf_reader }

      expect(described_class.exec('file_in_args')).to eq(["Text within pdf file"])
    end
  end # .exec
end
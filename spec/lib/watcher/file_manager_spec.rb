require 'spec_helper'

describe Watcher::FileManager do
  describe ".move" do
    it 'moves the file to another folder' do
      allow(File).to receive(:dirname)
      allow(Dir).to receive(:exists?){ true }

      expect(FileUtils).to receive(:mv).with(
        'from path', 'to path'
      )
      described_class.move('from path', 'to path')
    end

    context 'when the directory exists' do
      before do
        allow(File).to receive(:dirname)
        allow(Dir).to receive(:exists?){true}
        allow(FileUtils).to receive(:mv)
      end

      it 'doesnt creates this' do
        expect(described_class).to_not receive(:create_dir)
        described_class.move('from path', 'to path')
      end
    end

    context 'when the directory doesnt exists' do
      before do
        allow(File).to receive(:dirname){ 'directory name' }
        allow(Dir).to receive(:exists?){false}
        allow(FileUtils).to receive(:mv)
      end

      it 'doesnt creates this' do
        expect(described_class).to receive(:create_dir).with('directory name')
        described_class.move('from path', 'to path')
      end
    end
  end # .move

  describe '.create_dir' do
    it 'creates a new directory' do
      expect(FileUtils).to receive(:mkdir_p).with('directory to create')
      described_class.create_dir('directory to create')
    end
  end # .create_dir

  describe '.create_pdf' do
    it 'creates a new pdf reader' do
      expect(PDF::Reader).to receive(:new).with("file_pdf")
      described_class.create_pdf("file_pdf")
    end

    it 'returns that pdf reader' do
      allow(PDF::Reader).to receive(:new){ 'pdf reader file' }
      expect(described_class.create_pdf("file_pdf")).to eq('pdf reader file')
    end
  end # .create_pdf

  describe '.is_pdf?' do
    context 'when the file is a pdf' do
      let(:pdf_file) { File.expand_path("spec/support/text.pdf") }

      before do
        FileUtils.touch(
          File.expand_path("spec/support/text.pdf")
        )
      end

      it 'just returns true' do
        expect(described_class.is_pdf?(pdf_file)).to be_truthy
      end
    end

    context 'when the file isnt a pdf' do
      let(:non_pdf) { File.expand_path("spec/support/text.txt") }

      before do
        FileUtils.touch(
          File.expand_path("spec/support/text.txt")
        )
      end

      it 'just returns true' do
        expect(described_class.is_pdf?(non_pdf)).to be_falsey
      end
    end
  end # .is_pdf?

  describe ".move_to_tmp" do
    let(:config) { OpenStruct.new(:tmp_folder => 'tmp/folder/directory') }

    before do
      allow(Watcher).to receive(:config){ config }
      allow(File).to receive(:basename){ 'test.pdf' }
    end

    it 'moves to tmp folder' do
      expect(described_class).to receive(:move).with(
        'original/folder/test.pdf', 'tmp/folder/directory/test.pdf'
      )
      described_class.move_to_tmp('original/folder/test.pdf')
    end

    it 'returns the moved file' do
      allow(described_class).to receive(:move){ 'tmp/folder/directory/test.pdf' }
      expect(described_class.move_to_tmp('original/folder/test.pdf')).to eq(
        'tmp/folder/directory/test.pdf'
      )
    end
  end # .move_to_tmp
end
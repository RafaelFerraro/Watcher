describe Watcher do
  describe '.execute' do
    it 'daemonizes the ruby application' do
      expect(Daemons).to receive(:run_proc).with(
        'watcher'
      )
      described_class.execute
    end

    it 'starting to listen the folders to get the files' do
      allow(Daemons).to receive(:run_proc).and_yield

      expect(Watcher::Listener).to receive(:listen)
      described_class.execute
    end
  end
end
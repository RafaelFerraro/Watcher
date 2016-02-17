describe Notifier do
  module Notifier
    class Helper
    end
  end

  describe ".config" do
    context 'when config file is not found', focus: true do
      expect{ Helper.config }.to raise(LoadError)
    end

    context 'when config file is found' do

    end
  end
end
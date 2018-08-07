# frozen_string_literal: true

RSpec.describe LazyRotator do
  describe :File do
    describe :Delete do
      let(:test_log_path) { File.expand_path('../../dummy/test.log', __dir__) }

      let(:test_log) { LazyRotator::File::Delete.new(test_log_path) }

      describe :process do
        it 'deletes the file' do
          expect(File).to receive(:delete).with(test_log_path)
          test_log.process
        end
      end
    end
  end
end

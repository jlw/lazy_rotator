# frozen_string_literal: true

RSpec.describe LazyRotator do
  describe :File do
    describe :Touch do
      let(:test_log_path) { File.expand_path('../../dummy/test.log', __dir__) }

      let(:test_log) { LazyRotator::File::Touch.new(test_log_path) }

      describe :process do
        it 'touches the file' do
          expect(FileUtils).to receive(:touch).with(test_log_path)
          test_log.process
        end

        it 'creates the file if not there' do
          FileUtils.rm test_log_path
          expect(File.exist?(test_log_path)).to be false
          test_log.process
          expect(File.exist?(test_log_path)).to be true
        end
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe LazyRotator do
  describe :File do
    describe :Ignore do
      let(:test_log_path) { File.expand_path('../../dummy/test.log', __dir__) }

      let(:test_log) { LazyRotator::File::Ignore.new(test_log_path) }

      describe :process do
        it 'leaves the file in place' do
          expect(File.exist?(test_log_path)).to be true
          test_log.process
          expect(File.exist?(test_log_path)).to be true
        end
      end
    end
  end
end

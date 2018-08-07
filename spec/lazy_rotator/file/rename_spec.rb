# frozen_string_literal: true

RSpec.describe LazyRotator do
  describe :File do
    describe :Rename do
      let(:test_log_path) { File.expand_path('../../dummy/test.log', __dir__) }
      let(:test_log_four_path) { File.expand_path('../../dummy/test.log.4', __dir__) }

      let(:test_log) { LazyRotator::File::Rename.new(test_log_path, 1) }
      let(:test_log_four) { LazyRotator::File::Rename.new(test_log_four_path, 5) }

      describe :file_name do
        it 'matches the input' do
          expect(test_log.file_name).to eq test_log_path
        end
      end

      describe :file_name_without_number do
        it 'removes the current number from the file' do
          expect(test_log.file_name_without_number).to eq test_log_path
          expect(test_log_four.file_name_without_number).to eq test_log_path
        end
      end

      describe :new_file_name do
        it 'removes the current number from the file' do
          expect(test_log.new_file_name).to eq test_log_path + '.1'
          expect(test_log_four.new_file_name).to eq test_log_path + '.5'
        end
      end

      describe :new_number do
        it 'matches the input' do
          expect(test_log.new_number).to eq 1
        end
      end

      describe :== do
        it 'matches similar object' do
          dup_test_log = LazyRotator::File::Rename.new(test_log_path, 1)
          expect(test_log).to eq dup_test_log
        end

        it 'does not match disimilar object' do
          expect(test_log).not_to eq test_log_four
        end

        it 'does not match other class' do
          expect(test_log).not_to eq LazyRotator::File::Ignore.new(test_log_path)
          expect(test_log).not_to eq LazyRotator::File::Delete.new(test_log_path)
        end
      end

      describe :process do
        it 'renames the file' do
          expect(File).to receive(:rename).with(test_log_path, test_log_path + '.1')
          test_log.process
        end
      end
    end
  end
end

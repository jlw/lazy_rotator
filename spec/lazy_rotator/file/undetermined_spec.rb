# frozen_string_literal: true

RSpec.describe LazyRotator do
  describe :File do
    describe :Undetermined do
      let(:test_log_path) { File.expand_path('../../dummy/test.log', __dir__) }
      let(:test_log_four_path) { File.expand_path('../../dummy/test.log.4', __dir__) }

      let(:test_log) { LazyRotator::File::Undetermined.new(test_log_path) }
      let(:test_log_four) { LazyRotator::File::Undetermined.new(test_log_four_path) }

      describe :file_name do
        it 'matches the input' do
          expect(test_log.file_name).to eq test_log_path
        end
      end

      describe :number do
        it 'is extracted from the file name' do
          expect(test_log.number).to eq 0
          expect(test_log_four.number).to eq 4
        end
      end

      describe :== do
        it 'matches similar object' do
          dup_test_log = LazyRotator::File::Undetermined.new(test_log_path)
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

      describe :<=> do
        it 'sorts lower number first' do
          expect(test_log <=> test_log_four).to eq(-1)
        end

        it 'falls back to file name for duplicated numbers' do
          dup_log = LazyRotator::File::Undetermined.new(test_log_path + '.a')
          expect(test_log <=> dup_log).to eq(-1)
        end
      end

      describe :file_number do
        it 'finds numbers at the end of the filename' do
          expect(LazyRotator::File::Undetermined.file_number('test.log.1')).to eq 1
          expect(LazyRotator::File::Undetermined.file_number('test.log.29')).to eq 29
        end

        it 'defaults to zero if no numerical suffix' do
          expect(LazyRotator::File::Undetermined.file_number('test.log')).to eq 0
          expect(LazyRotator::File::Undetermined.file_number('test_log')).to eq 0
        end

        it 'defaults to zero if non-numerical suffix' do
          expect(LazyRotator::File::Undetermined.file_number('test.log.a')).to eq 0
        end

        it 'handles non-strings, e.g. Pathnames' do
          expect(LazyRotator::File::Undetermined.file_number(Pathname.new('test.log.a'))).to eq 0
        end
      end
    end
  end
end

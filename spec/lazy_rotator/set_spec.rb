# frozen_string_literal: true

RSpec.describe LazyRotator do
  describe :Set do
    let(:test_log_path) { File.expand_path('../dummy/test.log', __dir__) }
    let(:retention_limit) { 5 }

    subject { LazyRotator::Set.new(test_log_path, retention_limit) }

    describe :initialize do
      it 'reverses the prepared files' do
        files = LazyRotator::Set.send(:prepare_files, test_log_path, retention_limit)
        expect(subject.files).to eq files.reverse
      end

      it 'accepts Pathname and other non-String objects that implement #to_s' do
        files = LazyRotator::Set.send(:prepare_files, test_log_path, retention_limit)
        set = LazyRotator::Set.new(Pathname.new(test_log_path), retention_limit)
        expect(set.files).to eq files.reverse
      end
    end

    describe :collect_files do
      it 'finds all of the appropriate files' do
        set = LazyRotator::Set.send(:collect_files, test_log_path)
        expect(set.size).to eq 6
        expect(set.first.number).to eq 0
        expect(set.last.number).to eq 88
      end
    end

    describe :prepare_file do
      it 'renames the bare log file to .1' do
        file = prepare_file(nil, 1)
        expect(file).to be_a LazyRotator::File::Rename
        expect(file.number).to eq 0
        expect(file.new_number).to eq 1
      end

      it 'renames .1 to .2' do
        file = prepare_file(1, 2)
        expect(file).to be_a LazyRotator::File::Rename
        expect(file.number).to eq 1
        expect(file.new_number).to eq 2
      end

      it 'ignores .2 if new second' do
        file = prepare_file(2, 2)
        expect(file).to be_a LazyRotator::File::Ignore
        expect(file.number).to eq 2
      end

      it 'renames .4 if priors exist' do
        file = prepare_file(4, 5)
        expect(file).to be_a LazyRotator::File::Rename
        expect(file.number).to eq 4
        expect(file.new_number).to eq 5
      end

      it 'keeps .4 if missing a prior' do
        file = prepare_file(4, 4)
        expect(file).to be_a LazyRotator::File::Ignore
        expect(file.number).to eq 4
      end

      it 'deletes .5 if priors exist' do
        file = prepare_file(5, 6)
        expect(file).to be_a LazyRotator::File::Delete
        expect(file.number).to eq 5
      end

      it 'deletes .6 if one prior missing' do
        file = prepare_file(6, 6)
        expect(file).to be_a LazyRotator::File::Delete
        expect(file.number).to eq 6
      end

      it 'deletes .6 if priors exist' do
        file = prepare_file(6, 7)
        expect(file).to be_a LazyRotator::File::Delete
        expect(file.number).to eq 6
      end

      it 'renames .88 in our example' do
        file = prepare_file(88, 5)
        expect(file).to be_a LazyRotator::File::Rename
        expect(file.number).to eq 88
        expect(file.new_number).to eq 5
      end

      def prepare_file(number, next_number)
        log_path  = test_log_path
        log_path += ".#{number}" if number
        LazyRotator::Set.send(
          :prepare_file,
          LazyRotator::File::Undetermined.new(log_path),
          retention_limit - 1,
          next_number
        )
      end
    end

    describe :prepare_files do
      it 'finds all of the appropriate files' do
        set = LazyRotator::Set.send(:prepare_files, test_log_path, 4)
        expect(set.size).to eq 7
        expect(set.first.number).to eq 0
        expect(set.last.number).to eq 88
      end

      it 'prepares the files as expected' do
        set = LazyRotator::Set.send(:prepare_files, test_log_path, 5)

        expect(set[0]).to be_a LazyRotator::File::Touch
        expect(set[0].number).to eq 0

        expect(set[1]).to be_a LazyRotator::File::Rename
        expect(set[1].number).to eq 0
        expect(set[1].new_number).to eq 1

        expect(set[2]).to be_a LazyRotator::File::Rename
        expect(set[2].number).to eq 1
        expect(set[2].new_number).to eq 2

        expect(set[3]).to be_a LazyRotator::File::Rename
        expect(set[3].number).to eq 2
        expect(set[3].new_number).to eq 3

        expect(set[4]).to be_a LazyRotator::File::Ignore
        expect(set[4].number).to eq 4

        expect(set[5]).to be_a LazyRotator::File::Rename
        expect(set[5].number).to eq 6
        expect(set[5].new_number).to eq 5

        expect(set[6]).to be_a LazyRotator::File::Delete
        expect(set[6].number).to eq 88
      end
    end
  end
end

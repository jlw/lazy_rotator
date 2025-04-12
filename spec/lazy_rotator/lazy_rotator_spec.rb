# frozen_string_literal: true

RSpec.describe LazyRotator do
  it 'has a version number' do
    expect(LazyRotator::VERSION).not_to be nil
  end

  describe :rotate do
    let(:dir) { File.expand_path('../dummy-temp', __dir__) }
    let(:test_log_path) { File.join(dir, 'test.log') }

    let(:orig_files) do
      [
        '',
        '.1',
        '.2',
        '.4',
        '.6',
        '.88',
        '.9ignore',
        '.ignore'
      ].map { |ext| file_name(ext) }
    end

    let(:rotated_files) do
      [
        '',
        '.1',
        '.2',
        '.3',
        '.4',
        '.5',
        '.9ignore',
        '.ignore'
      ].map { |ext| file_name(ext) }
    end

    before(:each) do
      FileUtils.rm_r dir if Dir.exist? dir
      FileUtils.copy_entry File.expand_path('../dummy', __dir__), dir
      expect(strip_dir(list_files_from_dir)).to eq strip_dir(orig_files)
    end
    after(:each) do
      FileUtils.rm_r dir
    end

    it 'process the files as expected' do
      LazyRotator.rotate(test_log_path, 5)
      expect(strip_dir(list_files_from_dir)).to eq strip_dir(rotated_files)

      File.write(test_log_path, 'Hello, world!')
      expect(File.stat(test_log_path).size).to eq 13
      LazyRotator.rotate(test_log_path, 5)
      expect(strip_dir(list_files_from_dir)).to eq strip_dir(rotated_files)
      expect(File.stat(test_log_path).size).to eq 0
    end

    it 'prepares the files as expected' do
      expect(File).to receive(:delete).with(file_name('.88'))
      expect(File).to receive(:rename).with(file_name('.6'), file_name('.5'))
      expect(File).to receive(:rename).with(file_name('.2'), file_name('.3'))
      expect(File).to receive(:rename).with(file_name('.1'), file_name('.2'))
      expect(File).to receive(:rename).with(file_name, file_name('.1'))
      expect(FileUtils).to receive(:touch).with(file_name)

      LazyRotator.rotate(test_log_path, 5)
    end

    it 'does not continue if the file does not exist' do
      allow(LazyRotator::Set).to receive(:new).and_call_original

      LazyRotator.rotate(File.expand_path('../dummy-temp/foo.log', __dir__))

      expect(LazyRotator::Set).not_to have_received :new
    end

    def file_name(ext = '')
      File.join(dir, "test.log#{ext}")
    end

    def list_files_from_dir
      Dir.glob("#{dir}/*")
    end

    def strip_dir(files)
      files.map { |f| f.sub("#{dir}/", '') }
    end
  end
end

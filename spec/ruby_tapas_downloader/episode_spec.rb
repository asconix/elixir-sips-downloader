require 'spec_helper'

describe RubyTapasDownloader::Episode do
  subject(:episode) { RubyTapasDownloader::Episode.new title, link, files }

  let(:title)           { '999 Some: Ruby Tapas Episode with <<' }
  let(:link)            { 'http://example.com' }
  let(:files)           { [double(download: true), double(download: true)] }
  let(:sanitized_title) { '999-some-ruby-tapas-episode-with-<<' }

  specify('#title') { expect(episode.title).to eq(title) }
  specify('#link' ) { expect(episode.link ).to eq(link ) }
  specify('#files') { expect(episode.files).to eq(files) }
  specify '#sanitized_title' do
    expect(episode.sanitized_title).to eq(sanitized_title)
  end

  describe '#download' do
    let(:basepath)     { '/tmp/ruby-tapas' }
    let(:agent)        { double }
    let(:episode_path) { File.join basepath, sanitized_title }

    before { allow(FileUtils).to receive(:mkdir_p) }

    it 'creates folder for episode with sanitized title' do
      expect(FileUtils).to receive(:mkdir_p).with(episode_path)

      episode.download basepath, agent
    end

    it 'calls #download on each file' do
      files.each do |file|
        expect(file).to receive(:download).with(episode_path, agent)
      end

      episode.download basepath, agent
    end
  end
end

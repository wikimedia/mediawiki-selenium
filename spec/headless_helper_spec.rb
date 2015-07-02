require 'spec_helper'

module MediawikiSelenium
  describe HeadlessHelper do
    let(:env) { Environment.new(config.merge(headless: true)) }
    let(:config) { {} }

    describe '.create_or_reuse_display' do
      subject { HeadlessHelper.create_or_reuse_display(env) }

      let(:headless) { double('Headless') }

      before { allow(headless).to receive(:destroy) }
      after { HeadlessHelper.destroy_display }

      context 'called for the first time' do
        it 'creates, starts, and returns a new Headless' do
          expect(Headless).to receive(:new).and_return(headless)
          expect(headless).to receive(:start)
          expect(subject).to be(headless)
        end
      end

      context 'called a second time' do
        it 'only creates one Headless' do
          expect(Headless).to receive(:new).once.and_return(headless)
          expect(headless).to receive(:start).once

          2.times { HeadlessHelper.create_or_reuse_display(env) }
        end
      end
    end
  end
end

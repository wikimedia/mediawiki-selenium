require 'spec_helper'

module MediawikiSelenium
  describe ScreenshotHelper do
    let(:env) { Environment.new(config).extend(ScreenshotHelper) }

    let(:config) { {} }

    describe '#screenshot' do
      subject { env.screenshot(browser, name) }

      let(:config) { { screenshot_failures_path: 'screenshots' } }

      let(:browser) { double('Watir::Browser') }
      let(:name) { 'Some test name' }

      it 'takes a screenshot of the browser' do
        screenshot = double('Watir::Screenshot')
        expect(browser).to receive(:screenshot).and_return(screenshot)
        expect(screenshot).to receive(:save).with('screenshots/Some test name.png')

        subject
      end

      it 'returns the path to the image file' do
        screenshot = double('Watir::Screenshot')
        allow(browser).to receive(:screenshot).and_return(screenshot)
        allow(screenshot).to receive(:save)

        expect(subject).to eq('screenshots/Some test name.png')
      end
    end

    describe '#teardown' do
      subject { env.teardown(info) }

      let(:info) { { name: 'Some test name', status: status } }
      let(:status) { :passed }

      let(:browser) { double(Watir::Browser) }

      before do
        # mock {Environment#teardown}
        allow(env.browser_factory).to receive(:each) { |&blk| [browser].each(&blk) }
        allow(env.browser_factory).to receive(:teardown)
        allow(browser).to receive(:close)
      end

      it 'invokes the given block with each browser' do
        allow(env).to receive(:screenshot)

        expect { |blk| env.teardown(info, &blk) }.to yield_with_args(browser)
      end

      context 'configured to take screenshots of failures' do
        let(:config) { { screenshot_failures: true } }

        context 'when the test case has failed' do
          let(:status) { :failed }

          it 'takes a screenshot of each browser' do
            expect(env).to receive(:screenshot).with(browser, 'Some test name')
            subject
          end

          it 'includes each screenshot in the returned artifacts' do
            allow(env).to receive(:screenshot).and_return('Some test name.png')

            expect(subject).to include('Some test name.png')
            expect(subject['Some test name.png']).to eq('image/png')
          end
        end

        context 'when the test case has not failed' do
          let(:status) { :passed }

          it 'takes no screenshot' do
            expect(env).not_to receive(:screenshot)
            subject
          end
        end
      end

      context 'configured to not take screenshots of failures' do
        let(:config) { { screenshot_failures: false } }
        let(:status) { :failed }

        it 'takes no screenshot' do
          expect(env).not_to receive(:screenshot)
          subject
        end
      end
    end
  end
end

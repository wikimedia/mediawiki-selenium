require "spec_helper"

module MediawikiSelenium::BrowserFactory
  describe Base do
    let(:factory_class) { Class.new(Base) }
    let(:factory) { factory_class.new(browser_name) }
    let(:browser_name) { :lynx }

    describe ".bind" do
      subject { factory_class.bind(option_name, &block) }

      let(:option_name) { :foo }
      let(:block) { proc { } }

      it "adds a new default binding for the given option" do
        subject
        expect(factory_class.default_bindings).to include(option_name)
        expect(factory_class.default_bindings[option_name]).to include(block)
      end

      context "given no block" do
        subject { factory_class.bind(option_name) }

        it "raises an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    describe ".bindings" do
      subject { factory_class.bindings }

      before do
        factory_class.bind(:foo) {}
      end

      it "includes the base class's default bindings" do
        expect(subject).to include(Base.default_bindings)
      end

      it "includes its own bindings" do
        expect(subject).to include(factory_class.default_bindings)
      end
    end

    describe ".default_bindings" do
      subject { factory_class.default_bindings }

      it { is_expected.to be_a(Hash) }

      context "before any bindings are defined" do
        it { is_expected.to be_empty }
      end

      context "when bindings are defined" do
        before do
          factory_class.bind(:foo) {}
          factory_class.bind(:bar) {}
          factory_class.bind(:bar) {}
        end

        it "includes all defined bindings" do
          expect(subject).to include(:foo, :bar)
        end

        it "includes all bindings for the same option name" do
          expect(subject[:bar].length).to be(2)
        end
      end
    end

    describe "#bind" do
      subject { factory.bind(option_name, &block) }
      before { subject }

      let(:option_name) { :foo }
      let(:block) { proc { } }

      it "adds a new binding for the given option" do
        expect(factory.bindings).to include(option_name)
        expect(factory.bindings[option_name]).to include(block)
      end

      context "given no block" do
        subject { factory.bind(option_name) }

        it "will default to an empty block" do
          expect(factory.bindings[option_name]).not_to include(nil)
        end
      end
    end

    describe "#bindings" do
      subject { factory.bindings }

      before do
        factory_class.bind(:foo) {}
        factory.bind(:bar)
      end

      it "includes the class-level bindings" do
        expect(subject).to include(factory_class.bindings)
      end

      it "includes its own bindings" do
        expect(subject).to include(:bar)
      end
    end

    describe "#browser_for" do
      subject { factory.browser_for(config) }

      let(:config) { { foo: "x" } }

      let(:watir_browser) { double(Watir::Browser) }
      let(:capabilities) { double(Selenium::WebDriver::Remote::Capabilities) }

      before do
        expect(Selenium::WebDriver::Remote::Capabilities).to receive(browser_name).
          at_least(:once).and_return(capabilities)
        expect(capabilities).to receive(:browser_name).
          at_least(:once).and_return(browser_name)
      end

      it "creates a new Watir::Browser" do
        expect(Watir::Browser).to receive(:new).once.and_return(watir_browser)
        expect(subject).to be(watir_browser)
      end

      context "called more than once" do
        let(:config1) { config }

        context "with the same configuration" do
          let(:config2) { config }

          it "returns a cached browser" do
            expect(Watir::Browser).to receive(:new).once.and_return(watir_browser)
            expect(factory.browser_for(config1)).to be(factory.browser_for(config2))
          end
        end

        context "with different configuration" do
          let(:config2) { { foo: "y" } }

          it "returns two distinct browsers" do
            expect(Watir::Browser).to receive(:new).twice

            factory.browser_for(config1)
            factory.browser_for(config2)
          end
        end
      end
    end

    describe "#browser_options" do
      subject { factory.browser_options(config) }

      let(:config) { {} }

      let(:capabilities) { double(Selenium::WebDriver::Remote::Capabilities) }
      let(:client) { double(Selenium::WebDriver::Remote::Http::Default) }
      let(:options) { { desired_capabilities: capabilities, http_client: client } }

      before do
        expect(Selenium::WebDriver::Remote::Capabilities).to receive(browser_name).
          at_least(:once).and_return(capabilities)
        expect(Selenium::WebDriver::Remote::Http::Default).to receive(:new).
          and_return(client)
      end

      it { is_expected.to be_a(Hash) }
      it { is_expected.to include(desired_capabilities: capabilities, http_client: client) }

      context "with a binding" do
        context "and corresponding configuration" do
          let(:config) { { foo: "x" } }

          it "invokes the binding with the configured value" do
            expect { |block| factory.bind(:foo, &block) && subject }.to yield_with_args("x", options)
          end
        end

        context "but no configuration" do
          let(:config) { {} }

          it "never invokes the binding" do
            expect { |block| factory.bind(:foo, &block) && subject }.to_not yield_control
          end
        end
      end

      context "with a multi-option binding" do
        context "and complete configuration for all options" do
          let(:config) { { foo: "x", bar: "y" } }

          it "invokes the binding with the configured values" do
            expect { |block| factory.bind(:foo, :bar, &block) && subject }.to yield_with_args("x", "y", options)
          end
        end

        context "but incomplete configuration for all options" do
          let(:config) { { foo: "x" } }

          it "never invokes the binding" do
            expect { |block| factory.bind(:foo, :bar, &block) && subject }.to_not yield_control
          end
        end
      end
    end
  end
end

require "spec_helper"

module MediawikiSelenium::BrowserFactory
  describe Base do
    let(:factory_class) { Class.new(Base) }
    let(:factory) { factory_class.new(browser_type) }
    let(:browser_type) { :lynx }

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
      subject { factory.browser_for(env) }

      let(:env) { MediawikiSelenium::Environment.new(foo: "x", bar: "y") }

      let(:watir_browser) { double(Watir::Browser) }
      let(:capabilities) { double(Selenium::WebDriver::Remote::Capabilities) }

      before do
        factory.bind(:foo)

        expect(Selenium::WebDriver::Remote::Capabilities).to receive(browser_type).
          at_least(:once).and_return(capabilities)
      end

      it "creates a new Watir::Browser" do
        expect(Watir::Browser).to receive(:new).once.and_return(watir_browser)
        expect(subject).to be(watir_browser)
      end

      context "called more than once" do
        let(:env1) { env }

        context "with differing env configuration" do
          context "that is bound" do
            let(:env2) { MediawikiSelenium::Environment.new(foo: "z") }

            it "returns two distinct browsers" do
              expect(Watir::Browser).to receive(:new).twice

              factory.browser_for(env1)
              factory.browser_for(env2)
            end
          end

          context "that is not bound" do
            let(:env2) { MediawikiSelenium::Environment.new(foo: "x", bar: "z") }

            it "returns a cached browser" do
              expect(Watir::Browser).to receive(:new).once.and_return(watir_browser)
              expect(factory.browser_for(env1)).to be(factory.browser_for(env2))
            end
          end
        end

        context "with the same env configuration" do
          let(:env2) { MediawikiSelenium::Environment.new(foo: "x") }

          it "returns a cached browser" do
            expect(Watir::Browser).to receive(:new).once.and_return(watir_browser)
            expect(factory.browser_for(env1)).to be(factory.browser_for(env2))
          end
        end
      end
    end
  end
end

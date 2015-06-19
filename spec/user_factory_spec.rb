require 'spec_helper'

module MediawikiSelenium
  describe UserFactory do
    subject { factory }

    let(:factory) { UserFactory.new(api) }
    let(:api) { double('MediawikiApi::Client') }

    it { is_expected.to be_a(UserFactory) }

    describe '#create' do
      let(:rando) { 'x' * 10 }

      before do
        n = double('Fixnum')
        allow(Random).to receive(:rand).and_return(n)
        allow(n).to receive(:to_s).with(36).and_return(rando)
      end

      context 'given no ID' do
        it 'creates a new user like "User--<random 10 chars>"' do
          expect(api).to receive(:create_account).
            with("User-#{rando}", "Pass-#{rando}")

          factory.create
        end

        it 'returns the user name and password' do
          allow(api).to receive(:create_account)

          expect(factory.create).to eq(user: "User-#{rando}", password: "Pass-#{rando}")
        end
      end

      context 'given an ID' do
        it 'creates a new user like "User-<id>-<random 10 chars>"' do
          expect(api).to receive(:create_account).
            with("User-foo-#{rando}", "Pass-foo-#{rando}")

          factory.create(:foo)
        end

        it 'replaces underscores in IDs with dashes' do
          expect(api).to receive(:create_account).
            with("User-foo-bar-#{rando}", "Pass-foo-bar-#{rando}")

          factory.create(:foo_bar)
        end

        it 'returns the alternative user name and password' do
          allow(api).to receive(:create_account)

          expect(factory.create(:foo)).
            to eq(user: "User-foo-#{rando}", password: "Pass-foo-#{rando}")
        end
      end

      context 'called more than once' do
        it 'will not create the same account twice' do
          expect(api).to receive(:create_account).once.
            with("User-foo-#{rando}", "Pass-foo-#{rando}")

          factory.create(:foo)
          factory.create(:foo)
        end

        it 'returns the same user and password' do
          expect(api).to receive(:create_account).
            with("User-foo-#{rando}", "Pass-foo-#{rando}")

          expect(factory.create(:foo)).to be(factory.create(:foo))
        end
      end
    end
  end
end

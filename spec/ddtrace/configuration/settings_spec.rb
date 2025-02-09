require 'spec_helper'

require 'ddtrace/configuration/settings'

RSpec.describe Datadog::Configuration::Settings do
  subject(:settings) { described_class.new }

  describe '#tracer' do
    let(:tracer) { Datadog::Tracer.new }
    let(:debug_state) { tracer.class.debug_logging }
    let(:custom_log) { Logger.new(STDOUT) }

    context 'given some settings' do
      before(:each) do
        @original_log = tracer.class.log

        settings.tracer(
          enabled: false,
          debug: !debug_state,
          log: custom_log,
          hostname: 'tracer.host.com',
          port: 1234,
          env: :config_test,
          tags: { foo: :bar },
          instance: tracer
        )
      end

      after(:each) do
        tracer.class.debug_logging = debug_state
        tracer.class.log = @original_log
      end

      it 'applies settings correctly' do
        expect(tracer.enabled).to be false
        expect(debug_state).to be false
        expect(Datadog::Tracer.log).to eq(custom_log)
        expect(tracer.writer.transport.current_api.adapter.hostname).to eq('tracer.host.com')
        expect(tracer.writer.transport.current_api.adapter.port).to eq(1234)
        expect(tracer.tags[:env]).to eq(:config_test)
        expect(tracer.tags[:foo]).to eq(:bar)
      end
    end

    it 'acts on the tracer option' do
      previous_state = settings.tracer.enabled
      settings.tracer(enabled: !previous_state)
      expect(settings.tracer.enabled).to eq(!previous_state)
      settings.tracer(enabled: previous_state)
      expect(settings.tracer.enabled).to eq(previous_state)
    end
  end
end

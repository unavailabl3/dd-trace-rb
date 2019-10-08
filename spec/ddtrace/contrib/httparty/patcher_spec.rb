require 'spec_helper'
require 'ddtrace'
require 'httparty/request'

RSpec.describe Datadog::Contrib::HTTParty::Patcher do
  describe '.patch' do
    it 'adds RequestPatch to ancestors of Request class' do
      described_class.patch

      expect(HTTParty::Request.ancestors).to include(Datadog::Contrib::HTTParty::RequestPatch)
    end
  end
end

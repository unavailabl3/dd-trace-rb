module Datadog
  module Contrib
    module HTTParty
      # Patcher enables patching of 'httparty' module.
      module Patcher
        include Contrib::Patcher

        module_function

        def patched?
          done?(:httparty)
        end

        def patch
          do_once(:httparty) do
            require 'ddtrace/contrib/httparty/request_patch'

            ::HTTParty::Request.send(:include, RequestPatch)
          end
        end
      end
    end
  end
end

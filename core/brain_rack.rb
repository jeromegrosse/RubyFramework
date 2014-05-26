require File.join(File.dirname(__FILE__), 'router.rb')

module JFW
    class BrainRack
        attr_reader :router

        def initialize
            @router = JFW::Router.new
        end
    end
end

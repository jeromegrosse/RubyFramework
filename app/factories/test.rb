require File.join(@@APP_FOLDER + "/app/models/" + "test")
require File.join(@@APP_FOLDER + "/core/factory")

class Factory_Test < Factory

    def initialize
        super
        @table       = "test"
        @object_name = "Test"
    end

end
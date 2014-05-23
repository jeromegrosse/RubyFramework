APP_FOLDER = File.dirname(__FILE__) + '/../../'

require File.join(APP_FOLDER + "core/model")
require File.join(APP_FOLDER + "core/factory")
require "test/unit"

#Define dummy model
class Test_Model < Model
    attr_accessor :v1, :v2, :v3

    @v1
    @v2
    @v3

    def initialize
        super
        @table = 'test_table'
    end

    def query_save
        _query_save
    end


    def property_definition
        @properties = ['id', 'v1', 'v2', 'v3']
    end
end


class Test_Test_Model < Test::Unit::TestCase

    def test_query_save_case_save
        model = Test_Model.new
        model.v1 = 1
        model.v2 = 2
        model.v3 = 3

        assert_equal("INSERT INTO test_table (v1, v2, v3 ) VALUES ( '1', '2', '3' )", model.query_save)
    end


    def test_query_save_case_update
        model = Test_Model.new
        model.id = 0
        model.v1 = 1
        model.v2 = 2
        model.v3 = 3

        assert_equal("UPDATE test_table ( v1, v2, v3 ) VALUES ( '1', '2', '3' ) WHERE id = 0", model.query_save)
    end

end
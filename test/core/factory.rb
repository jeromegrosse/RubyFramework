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


    def property_definition
        @properties = ['id', 'v1', 'v2', 'v3']
    end
end



class Factory_Test < Factory

    def sql_find id
        _sql_find id
    end


    def build_object data
        _build_object data
    end


    def initialize
        super
        @table       = "test_table"
        @object_name = "Test_Model"
    end

end



class Test_Factory_Test < Test::Unit::TestCase

  def test_sql_find
    id = 3
    factory = Factory_Test.new

    assert_equal("SELECT * FROM test_table WHERE id = #{id}", factory.sql_find(id) )
  end


  def test_build_object
    hash = {'id' => 3,
            'v1' => 1,
            'v2' => 2,
            'v3' => 3}

    factory = Factory_Test.new
    object  = factory.build_object([hash])

    assert_equal(3, object.id)
    assert_equal(1, object.v1)
    assert_equal(2, object.v2)
    assert_equal(3, object.v3)
  end

end

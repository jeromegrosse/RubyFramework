require BASE_PATH + "/core/model.rb"
require BASE_PATH + "/core/factory.rb"

require "test/unit"

#Define dummy model
class Test_Model < JFW::Model
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



class Factory_Test < JFW::Factory

    def sql_find id
        _sql_find id
    end


    def sql_find_all arr_condition, pagination
        _sql_find_all arr_condition, pagination
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


  def test_sql_find_all_wo_conditions
    factory    = Factory_Test.new
    conditions = {}
    sql = factory.sql_find_all conditions, {:offset=>0, :per_page=>20}

    assert_equal("SELECT * FROM test_table LIMIT 0, 20", sql)
  end


  def test_sql_find_all_w_conditions
    factory    = Factory_Test.new
    conditions = {'id' => [3, 4, 10],
                  'v1' => 5}
    sql = factory.sql_find_all conditions, {:offset=>0, :per_page=>20}

    sql_answer = "SELECT * FROM test_table WHERE id IN ( 3, 4, 10 ) AND v1 = 5 LIMIT 0, 20"
    assert_equal(sql_answer, sql)
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


  def test_build_arr_object
    hash1 = {'id' => 3,
             'v1' => 1,
             'v2' => 2,
             'v3' => 3}

    hash2 = {'id' => 10,
             'v1' => 3,
             'v2' => 0,
             'v3' => 7}

    factory = Factory_Test.new
    arr_object  = factory.build_object([hash1, hash2])

    assert_equal(2, arr_object.length)

    assert_equal(3,  arr_object[0].id)
    assert_equal(1,  arr_object[0].v1)
    assert_equal(2,  arr_object[0].v2)
    assert_equal(3,  arr_object[0].v3)

    assert_equal(10, arr_object[1].id)
    assert_equal(3,  arr_object[1].v1)
    assert_equal(0,  arr_object[1].v2)
    assert_equal(7,  arr_object[1].v3)
  end


  def test_build_object_nil
    factory = Factory_Test.new
    arr_object  = factory.build_object([])

    assert_equal(true, arr_object.nil?)
  end


end

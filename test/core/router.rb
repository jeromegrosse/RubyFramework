require_relative BASE_PATH + "/core/router.rb"
require "test/unit"
require "yaml"

class Test_Router < JFW::Router

    def initialize
        super
        @plurals = YAML.load("tests: \"test\"\ncategories: \"category\"")
    end

    def get_route_array path
        _get_route_array path
    end
end


class Test_Test_Router < Test::Unit::TestCase

  def test_default_route
    router = Test_Router.new
    path   = '/'

    result = ['/', {:klass=>"Dashboard_Controller", :method=>"index", :directory=>"../../../app/controllers/dashboard/dashboard"}]

    route  = router.get_route_array path
    assert_equal(result, route)
  end


  def test_css
    router = Test_Router.new
    path   = '/something/something/style.css'

    result = [/style\.css$/, {:klass=>"Global_Controller", :method=>"style_css", :directory=>"../../../app/controllers/global_controller"}]

    route  = router.get_route_array path
    assert_equal(result, route)
  end


  def test_js
    router = Test_Router.new
    path   = '/something/something/scripts.js'

    result = [/scripts\.js$/, {:klass=>"Global_Controller", :method=>"scripts_js", :directory=>"../../../app/controllers/global_controller"}]

    route  = router.get_route_array path
    assert_equal(result, route)
  end


  def test_index_controller
    router = Test_Router.new
    path   = '/categories/'

    result = [/.*/, {:klass=>"Category_Controller", :method=>"index", :directory=>"../../../app/controllers/category/category"}]

    route  = router.get_route_array path
    assert_equal(result, route)
  end


  def test_index_controller_explicit
    router = Test_Router.new
    path   = '/categories/index'

    result = [/.*/, {:klass=>"Category_Controller", :method=>"index", :directory=>"../../../app/controllers/category/category"}]

    route  = router.get_route_array path
    assert_equal(result, route)
  end


  def test_custom_method
    router = Test_Router.new
    path   = '/tests/something'

    result = [/.*/, {:klass=>"Test_Controller", :method=>"something", :directory=>"../../../app/controllers/test/test"}]

    route  = router.get_route_array path
    assert_equal(result, route)
  end

end
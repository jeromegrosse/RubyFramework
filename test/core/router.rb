require_relative BASE_PATH + "/core/router.rb"
require "test/unit"
require "yaml"

class Test_Router < Router

    def initialize
        super
        @plurals = YAML.load("tests: \"test\"\ncategories: \"category\"")
    end

    def get_route_array path, method
        _get_route_array path, method
    end
end


class Test_Test_Router < Test::Unit::TestCase

  def test_default_route
    router = Test_Router.new
    path   = '/'
    method = 'get'

    result = ['/', {:klass=>"Dashboard", :method=>"index", :directory=>"dashboard/dashboard"}]

    route  = router.get_route_array path, method
    assert_equal(result, route)
  end


  def test_css
    router = Test_Router.new
    path   = '/something/something/style.css'
    method = 'get'

    result = [/style\.css$/, {:klass=>"Global", :method=>"style_css"}]

    route  = router.get_route_array path, method
    assert_equal(result, route)
  end


  def test_js
    router = Test_Router.new
    path   = '/something/something/scripts.js'
    method = 'get'

    result = [/scripts\.js$/, {:klass=>"Global", :method=>"scripts_js"}]

    route  = router.get_route_array path, method
    assert_equal(result, route)
  end


  def test_index_controller
    router = Test_Router.new
    path   = '/categories/'
    method = 'get'

    result = [/.*/, {:klass=>"Category", :method=>"index", :directory=>"/category/category"}]

    route  = router.get_route_array path, method
    assert_equal(result, route)
  end


  def test_index_controller_explicit
    router = Test_Router.new
    path   = '/categories/index'
    method = 'get'

    result = [/.*/, {:klass=>"Category", :method=>"index", :directory=>"/category/category"}]

    route  = router.get_route_array path, method
    assert_equal(result, route)
  end


  def test_custom_method
    router = Test_Router.new
    path   = '/tests/something'
    method = 'get'

    result = [/.*/, {:klass=>"Test", :method=>"something", :directory=>"/test/test"}]

    route  = router.get_route_array path, method
    assert_equal(result, route)
  end

end
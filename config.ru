require 'bundler'
require 'logger'

@@APP_FOLDER  = File.dirname(__FILE__) + "/"
@@development = true


Bundler.require
require File.join(File.dirname(__FILE__),'core', 'brain_rack')
use Rack::Reloader
require File.join(File.dirname(__FILE__),'core', 'request_controller')
BrainRackApplication = BrainRack.new

logger = Logger.new('log/app.log')
run RequestController.new
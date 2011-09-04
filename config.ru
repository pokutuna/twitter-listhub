$:.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__) + '/lib')

require 'sinatra'
require 'app'

run Sinatra::Application
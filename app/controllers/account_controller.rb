require 'digest/md5'
require 'net/http'
require 'json'

class AccountController < ApplicationController
  before_action :authenticate_user!
  def index
  end
end

require 'rubytter'

module Model
  module User
    @users = Hash.new

    def self.register(access_token)
      user = Model::Twitter.get_instance(access_token)
      @users[access_token.params[:screen_name]] = user
      return user
    end
  end
end

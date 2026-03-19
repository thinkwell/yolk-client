# Client with basic functions mocked out to stop calls from going to the server during tests
module YolkClient
  class MockClient
    class << self
      attr_accessor :users, :tokens, :groups

      def reset
        @users, @tokens, @groups = [], [], []
      end
    end

    attr_accessor :app_token

    @users = []
    @tokens = []
    @groups = []

    def get_cookie_info
      {:secure=>false, :domain=>".twyolktest.com"}
    end
    def authenticate_application(name = nil, password = nil)
      "MOCKAPPTOKEN"
    end

    def authenticate_user name, password, factors = nil
      (user = find_user_by_name(name)) && user.instance_variable_get('@password') && user.instance_variable_get('@password') == password ? new_user_token(name) : nil
    end
    def create_user_token name
      new_user_token(name) if find_user_by_name(name)
    end
    def invalidate_user_token token
      tokens.delete token
    end
    def is_valid_user_token? token, factors = nil
      tokens.include? token
    end
    def find_user name
      users.detect{|u| u.username == name || u.email == name || u.id == name}
    end

    def find_user_by_token token
      token && tokens.include?(token) && (name = /.+-TOKENFOR-(.+)$/.match(token)) && name[1] && find_user_by_name(name[1])
    end
    def add_user user
      if user && user.username && !find_user_by_name(user.username)
        self.class.users << user
        user
      end
    end
    def remove_user name
      user = users.delete(find_user_by_name(name))
      tokens.reject!{|t| t =~ /.+-TOKENFOR-#{user.username}/} if user && user.username
    end
    def update_user_credential name, credential, encrypted = false
      if user = find_user_by_name(name)
        user.instance_variable_set('@password', credential)
      end
    end
    def update_user user
      return unless user.dirty?

      attrs_to_update = user.dirty_attributes
      return if attrs_to_update.empty?

      stored_user = find_user_by_name(user.username)
      return if stored_user.blank?

      attrs_to_update.each do |a|
        stored_user.update({a => user.send(a)})
      end
      user.clean
    end

    private
    def new_user_token username
      random_token(username).tap{|t| tokens << t}
    end
    def random_token username
      "#{rand(36**10).to_s(36)}-TOKENFOR-#{username}"
    end

    def tokens; self.class.tokens; end
    def users; self.class.users; end
    def groups; self.class.groups; end

  end
end

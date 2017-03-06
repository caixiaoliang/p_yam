module Patterns
  class << self
    def mobile
      /\A1[0-9]{10}\z/
    end

    def email
      # /\A[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|club|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?\z/i
      /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end
  end
end
module Users
    class FetchAllService
      def self.call
        User.all
      end
    end
end

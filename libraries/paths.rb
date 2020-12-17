module MacOS
  class UserPath
    class << self
      def home(user)
        SystemPath.directory('Users', user)
      end

      def directory(user, *dirs)
        ::File.join(home(user), dirs)
      end

      def library(user)
        ::File.join(home(user), 'Library')
      end

      def preferences(user)
        ::File.join(home(user), 'Library/Preferences')
      end

      def plist(user, plist)
        ::File.join(preferences(user), plist)
      end
    end
  end

  class SystemPath
    class << self
      def directory(*dirs)
        ::File.join(root, dirs)
      end

      def root
        '/'
      end

      def library
        ::File.join(root, 'Library')
      end

      def preferences
        ::File.join(library, 'Preferences')
      end

      def plist(plist)
        ::File.join(preferences, plist)
      end
    end
  end
end

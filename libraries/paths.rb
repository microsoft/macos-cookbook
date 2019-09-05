module LabCore
  class UserPath
    class << self
      def home(user)
        SysPath.directory('Users', user)
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

  class SysPath
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
    end
  end
end

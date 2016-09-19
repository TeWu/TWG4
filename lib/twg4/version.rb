module TWG4
  module Version
    MAJOR = 0
    MINOR = 2
    PATCH = 0
    LABEL = nil
  end

  VERSION = ([Version::MAJOR, Version::MINOR, Version::PATCH, Version::LABEL].compact * '.').freeze
end

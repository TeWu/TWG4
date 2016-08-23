module ActiveSupport
  class TimeWithZone
    def standard_string_form
      localtime.strftime("%d.%m.%Y %H:%M:%S")
    end
  end
end

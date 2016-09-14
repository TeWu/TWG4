module TWG4
  module ERBHelpers
    class << self

      def render(partial_path, binding)
        dir_name, _, partial_name = partial_path.rpartition(File::SEPARATOR)
        file_name = "_#{partial_name}.html.erb"
        Erubis::Eruby.new(File.read(File.join(Rails.root, 'app', 'views', dir_name, file_name)).gsub("'", %q(\\\'))).result(binding)
      end

    end
  end
end

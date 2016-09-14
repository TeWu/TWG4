module TWG4
  raw_config = File.read File.join(Rails.root, 'config', 'app_config.yml')
  CONFIG = YAML.load(raw_config)[Rails.env].with_indifferent_access

  ##----- Additional config processing -----#
  for (name, spec) in CONFIG[:image_sizes]
    CONFIG[:image_sizes][name].merge!(as_array: [spec[:width], spec[:height]])
  end
  CONFIG[:roles_values] = CONFIG[:roles].map { |role, i| [role, 2**i] }.to_h
  CONFIG[:roles_values_inverse] = CONFIG[:roles_values].invert

  CONFIG.freeze
end

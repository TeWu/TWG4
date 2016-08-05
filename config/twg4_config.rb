module TWG4

  CONFIG = {
      image_sizes: {
          thumbnail: {width: 170, height: 170},
          medium: {width: 1920, height: 1080}
      },

      # Roles are defined like 'role_name: position_in_roles_bitmask'.
      # ! WARNING ! Be careful when changing position in roles bitmask for existing role - it can change whether or not this role is assigned to existing users.
      roles: {active: 0, moderator: 4, admin: 6, super_admin: 7} # NOTE: Roles should be positioned from the least to the most privileged (because of how permissions are defined in Ability). # NOTE: roles bitmask is usually 32 bits (4 bytes) long +- sign bit.
  }


  ##----- Additional config processing -----#

  for (name, spec) in CONFIG[:image_sizes]
    CONFIG[:image_sizes][name].merge!(as_array: [spec[:width], spec[:height]])
  end
  CONFIG[:roles_values] = CONFIG[:roles].map { |role, i| [role, 2**i] }.to_h
  CONFIG[:roles_values_inverse] = CONFIG[:roles_values].invert

  CONFIG.freeze
end


RSpec.describe TWG4::Serializers::RolesBitmaskSerializer do
  let(:serializer) { TWG4::Serializers::RolesBitmaskSerializer }

  specify { expect(serializer.load(0)).to eq [] }
  TWG4::CONFIG[:roles].each do |role, index|
    specify { expect(serializer.load(1 << index)).to eq [role] }
    specify { expect(serializer.load(role_val(:active) | 1 << index)).to eq ['active', role] } unless role == 'active'
    specify { expect(serializer.load(role_val(:admin) | 1 << index).sort).to eq ['admin', role].sort } unless role == 'admin'
  end

  specify { expect(serializer.dump([])).to eq 0 }

  [ [:active], ['moderator'], [:admin], [:super_admin],
    ['active', :moderator],
    [:active, 'admin'],
    ['active', 'super_admin'],
    [:active, :moderator, :admin],
    [:active, :moderator, :admin, :super_admin]
  ].each do |roles|
    specify { expect(serializer.dump(roles)).to eq roles_val(*(roles.map(&:to_sym))) }
  end


  def roles_val(*roles)
    roles.map(&method(:role_val)).reduce(:|)
  end

  def role_val(role)
    2**TWG4::CONFIG[:roles][role]
  end

end
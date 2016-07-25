class AllowNullInUserRolesBitmask < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :roles_bitmask, from: false, to: true
    change_column_default :users, :roles_bitmask, from: 0, to: nil
  end
end

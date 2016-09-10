# Create users
admin = User.create! username: "admin", display_name: "Admin", password: "admin", password_confirmation: "admin"

# Create special purpose albums
TWG4::AlbumSpecialPurpose::SPECIAL_PURPOSES_DEFINITIONS.keys.each do |special_album_purpose|
  Album.create! name: special_album_purpose.to_s.humanize, owner: admin, special_purpose: special_album_purpose
end

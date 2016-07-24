module AlbumsHelper

  def add_new_photo_link(album, content = "Add new photo")
    link_to(content, new_album_photo_path(album)) if can? :new, album => Photo
  end

  def add_existing_photo_link(album, content = "Add existing photo")
    link_to(content, add_photo_to_album_path(album)) if can? :add_photo, album
  end

  def remove_photo_link(album, photo, content = "Remove from album")
    link_to(content, remove_photo_from_album_path(album, photo), method: :delete) if can? :remove_photo, album
  end

end

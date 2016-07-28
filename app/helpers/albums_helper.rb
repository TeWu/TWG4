module AlbumsHelper

  def add_new_photo_link(album, content = "Add new photo")
    link_to(content, new_album_photo_path(album)) if can? :new, Photo and can? :add_new_photo, album
  end

  def add_existing_photo_link(album, content = "Add existing photo")
    link_to(content, add_photo_to_album_path(album)) if can? :add_existing_photo, album
  end

  def remove_photo_button(album, photo, content = "Remove from album", **options)
    destroy_button(remove_photo_from_album_path(album, photo), content, **options) if can? :remove_photo, album
  end

end

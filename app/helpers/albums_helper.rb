module AlbumsHelper

  def add_new_photo_link(album, content = nil)
    content ||= glyphicon('cloud-upload') + " Upload new photos"
    link_to(content, new_album_photo_path(album)) if can? :new, Photo and can? :add_new_photo, album
  end

  def add_existing_photo_link(album, content = nil)
    content ||= glyphicon('plus') + " Add photos from other album"
    link_to(content, add_photo_to_album_path(album)) if can? :add_existing_photo, album
  end

  def remove_photo_button(album, photo, content = nil, **options)
    if can? :remove_photo, album
      content ||= glyphicon('remove') + " Remove from album"
      options.merge!(add_class: 'btn-sm btn-thumbnail remove-photo-btn')
      destroy_button(remove_photo_from_album_path(album, photo), options) { content }
    end
  end


  def prev_photo_path(album, photo)
    prev_photo_id = album.prev_photo_id(photo)
    album_photo_path album.id, prev_photo_id if prev_photo_id
  end

  def next_photo_path(album, photo)
    next_photo_id = album.next_photo_id(photo)
    album_photo_path album.id, next_photo_id if next_photo_id
  end

end

module AlbumsHelper

  def add_new_photo_link(album)
    if can? :new, Photo and can? :add_new_photo, album
      dropdown_link_to_modal_form_for :photos_upload, glyphicon('cloud-upload') + " Upload new photos",
                                      modal: {title: "Upload photos", primary_btn: {value: "Upload"}},
                                      form: {url: album_photos_path(album), validate: false, html: {multipart: true}} do |f|
        f.file_field :files, multiple: true
      end
    end
  end

  def add_existing_photo_link(current_album, albums_from, albums_to)
    if can? :add_existing_photo, Album
      dropdown_link_to_modal glyphicon('plus') + " Add photos from other album", modal: {title: "Add photos", primary_btn: {id: "add-photo-select-albums-btn"}} do
        render partial: 'photos_in_albums/add_existing_photo_form', locals: {current_album: current_album, albums_from: albums_from, albums_to: albums_to}
      end
    end
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

  def path_to_album_page_with_photo(album, photo)
    page = album.page_with(photo)
    album_path(album, page: page == 1 ? nil : page)
  end

end

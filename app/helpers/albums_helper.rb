module AlbumsHelper

  def add_new_photo_link(album)
    dropdown_link_to_modal_form_for :photos_upload, icon_label('cloud-upload', "Upload new photos"),
                                    modal: {title: "Upload photos", primary_btn: {value: "Upload", id: 'upload-photos-submit-btn'}},
                                    form: {url: album_photos_path(album), validate: false, html: {multipart: true}} do |f|
      fieldset_elem = field_set(id: 'photos-upload-fieldset') do
        f.file_field(:files, multiple: true)
      end
      spinner_elem = content_tag(:div, id: 'photos-upload-spinner-container', style: 'display: none', hidden: true) do
        render('spinner', variant: 'big') + content_tag(:div, class: 'spinner-label') { "Uploading&hellip;".html_safe }
      end
      safe_join [fieldset_elem, spinner_elem]
    end
  end

  def add_existing_photo_link(current_album, albums_from, albums_to)
    dropdown_link_to_modal icon_label('plus', "Add photos from other album"), modal: {title: "Add photos", primary_btn: {id: "add-photo-select-albums-btn"}} do
      render partial: 'photos_in_albums/add_existing_photo_form', locals: {current_album: current_album, albums_from: albums_from, albums_to: albums_to}
    end
  end

  def remove_photo_button(album, photo, content = nil, **options)
    content ||= icon_label('remove', "Remove from album")
    options.merge!(add_class: 'btn-sm btn-thumbnail remove-photo-btn')
    destroy_button(remove_photo_from_album_path(album, photo), options) { content }
  end


  def prev_photo_url(album, photo, **options)
    prev_photo_id = album.prev_photo_id(photo)
    album_photo_url album, prev_photo_id, options if prev_photo_id
  end
  def prev_photo_path (album, photo, **options)
    prev_photo_url(album, photo, {only_path: true}.merge!(options))
  end

  def next_photo_url(album, photo, **options)
    next_photo_id = album.next_photo_id(photo)
    album_photo_url album, next_photo_id, options if next_photo_id
  end
  def next_photo_path (album, photo, **options)
    next_photo_url(album, photo, {only_path: true}.merge!(options))
  end

  def path_to_album_page_with_photo(album, photo)
    page = album.page_with(photo)
    album_path(album, page: page == 1 ? nil : page)
  end

end

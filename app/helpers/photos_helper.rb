module PhotosHelper

  def photo_image(photo, version = :default, options = {})
    image_url = photo ? photo.image_url(version) : Photo.new.image.send(version.to_sym).default_url
    image_alt = photo ? "Photo" : "Photo Placeholder"
    image_options = {alt: image_alt}.merge(version == :default ? options : options.merge(class: "photo-#{version}-img"))
    image_tag image_url, image_options
  end

  def photo_nav_buttons(current_album, current_photo)
    prev_photo_path = prev_photo_path(current_album, current_photo)
    prev_photo_btn = button_to prev_photo_path, method: :get,
                               id: 'prev-photo-btn',
                               class: 'btn btn-default btn-in-group-leftmost',
                               form_class: :single_button_form,
                               disabled: prev_photo_path.nil? do
      glyphicon 'arrow-left'
    end
    next_photo_path = next_photo_path(current_album, current_photo)
    next_photo_btn = button_to next_photo_path, method: :get,
                               id: 'next-photo-btn',
                               class: 'btn btn-default btn-in-group-rightmost',
                               form_class: :single_button_form,
                               disabled: next_photo_path.nil? do
      icon_label 'arrow-right', "Next", icon_position: :right
    end
    prev_photo_btn + next_photo_btn
  end

end

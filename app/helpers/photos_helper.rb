module PhotosHelper

  def photo_image(photo, version = :default, options = {})
    image_url = photo ? photo.image_url(version) : Photo.new.image.send(version.to_sym).default_url
    image_alt = photo ? "Photo" : "Photo Placeholder"
    image_options = {alt: image_alt}.merge(version == :default ? options : options.merge(class: "photo-#{version}-img"))
    image_tag image_url, image_options
  end

end

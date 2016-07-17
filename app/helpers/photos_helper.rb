module PhotosHelper

  def photo_image(photo, version = :default, options = {})
    image_url = photo.image_url(version)
    image_options = {alt: "Photo"}.merge(version == :default ? options : options.merge(class: "photo-#{version}-img"))
    image_tag image_url, image_options
  end

end

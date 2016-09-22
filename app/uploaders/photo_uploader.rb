# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  THUMBNAIL_SIZE = TWG4::CONFIG[:image_sizes][:thumbnail]
  THUMBNAIL_GENERATION_MARGIN = 30
  MEDIUM_SIZE = TWG4::CONFIG[:image_sizes][:medium]
  MEDIUM_GENERATION_MARGIN = 200

  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}_#{mounted_as.to_s.pluralize}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end


  # Process files as they are uploaded:
  process :auto_orient
  process resize_to_limit: MEDIUM_SIZE[:as_array]

  # Create different versions of your uploaded files:
  version :thumbnail, if: :generate_thumbnail? do
    process resize_to_limit: THUMBNAIL_SIZE[:as_array]
  end
  version :medium, if: :generate_medium? do
    process resize_to_limit: MEDIUM_SIZE[:as_array]
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here. Avoid model.id, because id is still nil when file is saved. See uploader/store.rb for details.
  def filename
    if original_filename
      var = :"@#{mounted_as}_unique_file_name"
      model.instance_variable_get(var) or model.instance_variable_set(var, unique_file_name)
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility: ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "/assets/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  def serializable_hash(options = nil)
    {"url" => url}.merge Hash[versions.map { |name, version| [name, {"url" => model.try { |m| m.image_url(name) } || version.url}] }]
  end


  protected

  def unique_file_name
    if original_filename
      loop do
        name = "#{SecureRandom.uuid}.#{file.extension}"
        break name unless Photo.exists?(image: name)
      end
    end
  end

  def auto_orient
    manipulate! { |img| img.tap(&:auto_orient) } # Rotates the image based on the EXIF Orientation
  end

  def generate_thumbnail?(picture)
    image = MiniMagick::Image.open(picture.path)
    image.width > THUMBNAIL_SIZE[:width] + THUMBNAIL_GENERATION_MARGIN || image.height > THUMBNAIL_SIZE[:height] + THUMBNAIL_GENERATION_MARGIN
  end

  def generate_medium?(picture)
    image = MiniMagick::Image.open(picture.path)
    image.width > MEDIUM_SIZE[:width] + MEDIUM_GENERATION_MARGIN || image.height > MEDIUM_SIZE[:height] + MEDIUM_GENERATION_MARGIN
  end

end

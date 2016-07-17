# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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
  # process resize_to_limit: [4096, 2160]

  # Create different versions of your uploaded files:
  version :thumbnail do
    process resize_to_limit: TWG4::CONFIG[:image_sizes][:thumbnail][:size]
  end
  version :medium do
    process resize_to_limit: TWG4::CONFIG[:image_sizes][:medium][:size]
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
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end


  protected

  def unique_file_name
    if original_filename
      loop do
        name = "#{SecureRandom.uuid}.#{file.extension}"
        break name unless Photo.exists?(image: name)
      end
    end
  end

end

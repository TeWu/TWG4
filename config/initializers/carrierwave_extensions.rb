module DropboxFileExtensions

  def url
    @cached_url ||= super
  end

  # Checks if file exists by checking if url method raises an exception
  def exists?
    @cached_exists ||= begin
      url
      true
    rescue Exception
      false
    end
  end

end
CarrierWave::Storage::Dropbox::File.prepend DropboxFileExtensions

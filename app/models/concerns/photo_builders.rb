module PhotoBuilders

  def build_from_files(files)
    album = proxy_association.owner
    display_order = album.display_order_for_new_photo
    files.map.with_index do |file, i|
      build(image: file).tap do |photo|
        photo.photo_in_albums.first.display_order = display_order + i
      end
    end
  end

end

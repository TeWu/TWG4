module TWG4
  class AlbumSpecialPurpose
    SPECIAL_PURPOSES_DEFINITIONS = {
        orphaned_photos: {
            photos: -> { Photo.left_outer_joins(:photo_in_albums).where(photos_in_albums: {id: nil}) }
        }
    }

    attr_reader :special_purpose

    def initialize(special_purpose)
      @special_purpose = special_purpose.to_sym
    end


    def attrs
      @attrs ||= SPECIAL_PURPOSES_DEFINITIONS[special_purpose]
    end

    def photos
      attrs[:photos].call
    end

    def order_by_attribute
      attrs[:order_by_attribute] || :id
    end

    def ordered_photos
      photos.order(order_by_attribute)
    end

    def neighbour_photo_id(current_photo, is_prev)
      rel, sort_order = is_prev ? ['<', 'DESC'] : ['>', 'ASC']
      photos.order("#{order_by_attribute} #{sort_order}")
          .where(["#{Photo.table_name}.#{order_by_attribute} #{rel} ?", current_photo[order_by_attribute]])
          .limit(1).pluck(:id).first
    end

  end
end

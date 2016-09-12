module URLSegmentSupport

  def self.[](attribute, **options)
    Module.new do
      extend ActiveSupport::Concern

      included do
        acts_as_url attribute, options.reverse_merge!(url_attribute: :url_segment, sync_url: true)

        def to_param
          url_segment
        end

        def self.find_by_param!(param)
          find_by! url_segment: param
        end
      end

    end
  end

end

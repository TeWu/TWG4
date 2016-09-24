class MaintenanceController < ApplicationController
  skip_authorization_check
  before_action do
    head :forbidden unless current_user.try(:id) == TWG4::CONFIG[:demo][:real_admin_user_id]
  end

  def resource_hashes
    resource_classes = [User, Album, Photo, PhotoInAlbum, Comment]
    hashes = resource_classes.map do |c|
      {c.model_name.plural => Digest::SHA256.hexdigest(c.order(:id).to_a.map(&:attributes).inspect)}
    end.inject({}) { |a, e| a.merge!(e) }
    render json: hashes
  end

end

class CallbacksController < ApplicationController
  respond_to :json
  def image_upload_callback
    upload_info = JSON.parse(params.keys[0])
    user = User.find(upload_info["id"].to_i)
    user.profile.update_attribute(:avatar, upload_info['hash'])
    render json: {"success": true}
  end
end

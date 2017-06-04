class CallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  def image_upload_callback
    upload_info = JSON.parse(params.keys[0])
    if upload_info["id"].present?
      # 处理头像上传逻辑
      user = User.find(upload_info["id"].to_i)
      user.profile.update_attribute(:avatar, upload_info['hash'])
    end
    render json: {success: true, file_path: image_path(upload_info['hash'])}
  end
end

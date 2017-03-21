module ApplicationHelper
  require 'qiniu'
  def titled(collection,opt={})
    raise "link option is required" unless opt[:link]
    opt[:columns] ||= 3
    opt[:thumbnail] ||= lambda{|item| image_tag(item.photo.public_filename(:thumb))}
    opt[:title] ||= ->(item){item.to_s}
    opt[:description] ||= ->(item){ item.description}

    render "shared/_titled_table",
      collection: collection,
      link: opt[:link],
      title: opt[:title],
      description: opt[:description],
      thumbnail: opt[:thumbnail],
      columns: opt[:columns]
  end

  def photo_for(user,size= :thumb)
    
  end

  def gravatar_for(user,options={width: "100"})
    width = options[:width]
    # 2根据图片在七牛的hash显示图片
    # @image=user.
   
    defaultpic='da8e974dc_xl.jpg'
    if user.avatar.present?
      image_tag(qiniu_image_by_hash(user.avatar,format: "square",width: width))
    else
      image_tag(qiniu_image_by_hash(defaultpic,format: "square",width: width))
    end
  end


  def generate_qiniu_upload_token
    bucket = "chenxiyue"
    put_policy=Qiniu::Auth::PutPolicy.new(bucket) #参数是七牛bucket名
    # put_policy.scope!("chenxiyue",key)
    callback_body={
      fname: '$(fname)',
      hash: '$(etag)',
      id:  '$(x:id)'
    }.to_json
      # 构建回调策略，这里上传文件到七牛后， 七牛将文件名和文件大小回调给业务服务器.
    # callback_body = 'filename=$(fname)&filesize=$(fsize)' # 魔法变量的使用请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar
    # put_policy.callback_url= upload_callback_users_url
    put_policy.callback_body= callback_body
    put_policy.callback_url= image_upload_callback_callbacks_url  #上传成功后回调的URL
    Qiniu::Auth.generate_uptoken(put_policy)
  end

  def qiniu_image_by_hash(hash, opt={})
    url="http://7xsr0z.com2.z0.glb.clouddn.com/#{hash}"    #为了方便硬编码七牛的域名
    format = opt[:format]
    width = opt[:width]
    height = opt[:height]

    case format
    when "square"
      url << "?imageView2/1/w/#{width}/h/#{width}/q/90"
    when "preview"
      url << "?imageView2/2/w/#{width}/h/#{height}/q/90"
    else
      url
    end
  end

  # Override the filename of the uploaded files:
  def filename
    @name = Digest::MD5.hexdigest(Time.now.utc.to_i.to_s + '-' + Process.pid.to_s + '-' + ("%04d" % rand(9999)))
    "#{@name}"
  end
end

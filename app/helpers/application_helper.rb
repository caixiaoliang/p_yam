module ApplicationHelper
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
end

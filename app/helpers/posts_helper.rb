module PostsHelper
  def fuzzy_truncate_html(text, length, suffix="")
    # Helper to fuzzy truncate text with html
    # There are better ways of doing this but this seems to work

    if (length < text.length)
      # Truncate by raw length (hence, fuzzy)
      text = text[0...length]

      # Chop off any half-baked tags at the end
      # E.g. `<strong>hello</str` becomes `<strong>hello`
      text.gsub! /<[^>]+$/, ''

      # Add ellipsis
      text += "..."

      # Use Nokogiri to repair the HTML (close unclosed tags)
      text = Nokogiri::HTML::DocumentFragment.parse(text).to_html

      # Add suffix
      text += suffix
    end

    text.html_safe
  end

  def post_cut(post)
    fuzzy_truncate_html post.description, 600
  end

  def post_lead(post)
    fuzzy_truncate_html post.description, 220
  end

  def post_category_collection(post)
    BlogCategory.all.order(:blog_type, :name).map do |c|
      ["#{c.name} [#{c.blog_type}]", c.id]
    end
  end

  def fb_feed_iframe(blog_type)
    blog_type = {
      vce: "VCE",
      hsc: "HSC",
      umat: "UMAT",
      gamsat: "GAMSAT",
    }[blog_type.to_sym]

    url = "https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FGradReady#{blog_type}&tabs=timeline&width=360&height=500&small_header=false&adapt_container_width=true&hide_cover=false&show_facepile=true&appId"
    content_tag :iframe, nil, {
      :allowtransparency => "true",
      :frameborder => "0",
      :height => "500",
      :scrolling => "no",
      :src => url,
      :style => "border:none;overflow:hidden",
      :width => "360"
    }
  end
end

module EditorParsable extend ActiveSupport::Concern
  require 'rmagick'
  included do
    before_save :parse_editor_field
  end

  def parse_editor_field
    retrieve_text_fields.each { |attribute|
      write_attribute(attribute, search_for_picture(eval "self.#{attribute}"))
    }

  end

  private
  def search_for_picture text
    html = Nokogiri::HTML(text)
    html.search('img').each { |img|
      ['jpeg', 'jpg', 'gif', 'png'].each { |format|
        if img['src'][format] && img['src']['base64']
          img['src'] = decode_base64_image(img['src'].gsub("data:image/#{format};base64,", ''))
        end
      }
    }
    html.to_html
  end

  def retrieve_text_fields
    self.attributes.keys.select { |attribute_key|
      self.column_for_attribute(attribute_key).type.equal?(:text)
    }
  end

  def decode_base64_image image_data
    if image_data
      ActiveRecord::Base.transaction do
        decoded_data = Base64.decode64(image_data)
        image = Magick::Image.from_blob(decoded_data).first
        if image
          image_format = image.format.underscore
          content_type = "image/#{image_format}"
          data = StringIO.new(decoded_data)
          data.class_eval do
            attr_accessor :content_type, :original_filename
          end
          data.content_type = content_type
          data.original_filename = File.basename("#{SecureRandom.urlsafe_base64}.#{image_format}")
          ckeditor_picture = Ckeditor::Picture.new
          ckeditor_picture.data = data
          ckeditor_picture.save!
          ckeditor_picture.data.url(:original)
        end
      end
    end
  end
end

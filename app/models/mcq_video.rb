class McqVideo < ApplicationRecord
	belongs_to :mcq
	has_attached_file :video, styles: {
	    :thumbnail => { :geometry => "192x108#", :format => 'png', :time => 5 }
	  }, :processors => [:transcoder]
	#after_commit :create_transcoding_worker, on: [:create, :update]
  	validates_attachment_content_type :video, content_type: %w(video/mp4 video/flv video/avi video/wmv video/x-ms-wmv video/mov)

  def generate_output_path_for(resolution)
	    path = video(:"#{resolution}").split('/')[3..-2]
	    path << video_file_name
	    path.join('/')
	end

	def generate_output_url_for(resolution)
	    "https://#{ENV['S3_HOST_ALIAS']}/#{CGI.escape generate_output_path_for(resolution)}"
	end

	def generate_thumbnail_url
	    path = video(:thumbnail).split('/')[3..-2]
	    path << 'thumbnail-00002.png'
	    path = path.join('/')
	    url = "https://#{ENV['S3_HOST_ALIAS']}/#{path}"
	    return check_if_thumbnail_exists(url) ? url : regenerate_thumbnail_url
	end

	def generate_thumbnail_path
	    path = video(:thumbnail).split('/')[3..-2]
	    path << 'thumbnail-{count}'
	    path.join('/')
	end

	private

	  def create_transcoding_worker
	    if  previous_changes[:video_file_name].present? || previous_changes[:video_file_size].present? || previous_changes[:video_updated_at].present?
	      video_path = video.path
	      video_path.slice!(0)
	      elastictranscoder = Aws::ElasticTranscoder::Client.new(region: ENV['AWS_REGION'])
	      elastictranscoder.create_job(
	        pipeline_id: ENV['AWS_PIPELINE_ID'],
	        input: {
	          key: video_path
	        },
	        outputs: [
	          {
	            key: generate_output_path_for('720p'),
	            thumbnail_pattern: generate_thumbnail_path,
	            preset_id: '1351620000001-000010' # 720p
	          },
	          {
	            key: generate_output_path_for('360p'),
	            preset_id: '1351620000001-000040' # 360p

	          }
	        ]
	      )
	    end
	  end

	  def check_if_thumbnail_exists(url)
	    uri = URI(url)
	    request = Net::HTTP.new uri.host
	    response = request.request_head uri.path
	    return response.code.to_i == 200
	  end

	  def regenerate_thumbnail_url
	    path = video(:thumbnail).split('/')[3..-2]
	    path << 'thumbnail-00001.png'
	    path = path.join('/')
	    "https://#{ENV['S3_HOST_ALIAS']}/#{path}"
	  end
end

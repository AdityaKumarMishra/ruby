namespace :download_hit_counter do
    task create_download_hit_counter: :environment do
        DownloadHitCounter.files.keys.each do |file_name|
            file_int_val = DownloadHitCounter.files[file_name]
            DownloadHitCounter.create(file: file_name, download_count: 0) if DownloadHitCounter.find_by(file: file_int_val).nil? 
        end
    end

    task update_post_read_counter: :environment do
    	Post.all.each do |post|
    		post.update_attribute(:read_count, rand(500..2000))
    	end
    end
end

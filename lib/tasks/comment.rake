namespace :comment do
  task destroy_comments_without_commentable: :environment do
    Comment.all.select{ |comment| comment.commentable.nil?}.each do |comment|
      comment.destroy
    end
  end
end

namespace :update_podcast do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="
    Podcast.find_by(id: 1).update(title_tag: "GAMSAT Podcast: EP.01: GAMSAT Exam Prep from a Non Science Background", meta_description: "There's no doubt the GAMSAT exam is challenging, especially so for students from a non-science background.Join Nick and Alisha as they explain how to best prepare for the GAMSAT Exam without a science background and discuss how the exam has changed such that this is no longer the disadvantage it used to be. Tune in as they cover preparation techniques, mindsets, effective resources, and personal experience along with tips and tricks to optimise your plan and preparation for the GAMSAT Exam.")
    Podcast.find_by(id: 2).update(title_tag: "GAMSAT Podcast EP.02: Educated Guessing", meta_description: "Ever wondered how educated guessing can help you in the GAMSAT exam? Join Nick and Alisha as they explain how to improve your chances to correctly answer difficult MCQs in the GAMSAT Exam using educated guessing. Tune in as they cover tips and tricks to optimise your plan and preparation for the March GAMSAT Exam.")
    Podcast.find_by(id: 3).update(title_tag: "GAMSAT Podcast EP.03: Journey to Medical School and Challenges Faced", meta_description: "Want to know what to expect from the medical school entry journey? Join Nick and Alisha as they talk about their personal experiences of getting into medical school and the challenges faced. Tune in as they cover tips and tricks to optimise your plan and preparation to get into med school.")
    Podcast.find_by(id: 4).update(title_tag: "GAMSAT Podcast EP.04: GAMSAT Stress Management Strategies", meta_description: "A lot rides on the GAMSAT exam and stress can get the most of a lot of people, causing them to underperform. Join Nick and Alisha in the fourth episode of GradReady's GAMSAT to Med School Podcast as they talk about stress management strategies that you can use before and during the exam to ensure that you do the best that you possibly can.")
    puts "=============== Task End ==============="
  end

  task create_ep_14: :environment do
  	Podcast.create!(title: 'EP.14: MMIs vs Panel Interviews - How to Prepare?',
  					uploaded_on: Date.today.to_s,
  					duration: '35:14',
  					ep_desc: "<p>Join Felicity and Kayley in the fourteenth episode of GradReady's GAMSAT to Med School Podcast as they talk about how to prepare for MMI (Multiple Mini Interviews) and Panel Interviews.</p>",
  					full_desc: "<p>Join Felicity and Kayley in the fourteenth episode of GradReady's GAMSAT to Med School Podcast as they talk about how to prepare for MMI (Multiple Mini Interviews) and Panel Interviews.</p>",
  					frame_url: 'https://anchor.fm/gamsat-to-medschool/embed/episodes/Episode-14-MMIs-vs-Panel-Interviews---How-to-Prepare-e1mb3ka/a-a8c6mn7',
  					title_tag: 'P.14: MMIs vs Panel Interviews - How to Prepare?',
  					meta_description: "Join Felicity and Kayley in the fourteenth episode of GradReady's GAMSAT to Med School Podcast as they talk about how to prepare for MMI (Multiple Mini Interviews) and Panel Interviews.")
  end

  task update_ep_14: :environment do
  	podcast = Podcast.find_by(title: 'EP.14: MMIs vs Panel Interviews - How to Prepare?')

  	if podcast.present?
  		podcast.update!(video_url: 'https://gradready.s3.ap-southeast-2.amazonaws.com/vods/videos/000/000/011/Original/Podcast+14+Full+-+MMIs+vs+Panel+Interviews+-+How+to+Prepare.mp4')
  		puts 'Succesfully updated podcast EP:14 video URL'
  	end
  end
end

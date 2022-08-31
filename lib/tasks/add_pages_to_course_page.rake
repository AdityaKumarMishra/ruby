namespace :add_pages_to_course_page do
	task create_page_for_course_page: :environment do
		page_name = ["All Course Active", "Last Minute Preparation"]
		page_name.each do |name|
			CoursePage.create(name: name, active_page: true)
		end
	end
	task create_course_for_last_min_prepration: :environment do
		LastMinCourse.create([{ course_name: "Weekend Revision Course",
													  date: "Feb 29 & March 1",
													  amount: 359, 
													  description:"A fast paced course for those who only have the time to attend a 2 day course. Our expert tutors have constructed this course to cover the absolute essentials of the GAMSAT ® exam given the time constraints. Not a substitute for our more in-depth full attendance courses, this Summary Weekend is perfect however for those who are short on time or would like a recap just before the exam.",
													  course_type: 0},
   												{ course_name: "Mock Exam Day + Mock Exam Day Recap",
   													date: "March 7 & March 14",amount: 229, 
   													description:"The closest thing to the actual GAMSAT ® exam - you will be put under time pressure in a well-simulated test environment. Then our expert tutors will go through all of the MCQs with you the next day and give you personalised feedback on your essays within the week. In addition, your performance will be compared with those by other GradReady students, and you'll be given a percentile in each of the 3 sections and overall.",
   													course_type: 0}])
	end
end
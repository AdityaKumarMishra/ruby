f = File.open("./gamsat.json","r")
my_mcq = JSON.parse(f.readline)

stem = McqStem.create(
	title: my_mcq["stem_mcq"]["title"],
	published: my_mcq["stem_mcq"]["published"],
	description: my_mcq["stem_mcq"]["description"],
	difficulty: my_mcq["stem_mcq"]["difficulty"]
	)
stem.tags = [Tag.find_by_name(my_mcq["stem_mcq"]["tag"])]

stem.save!

my_mcq["child_mcqs"].each do |child|

	child_q = child["description"]
	child_exp = child["explanation"]

	child_mcq = Mcq.create(
		question: child_q,
		explanation: child_exp,
		publish: my_mcq["stem_mcq"]["published"],
		examinable: false,
		rating: child["rating"],
		difficulty: my_mcq["stem_mcq"]["difficulty"],
		mcq_stem_id: stem.id
		)
	child_mcq.tag = Tag.find_by_name(my_mcq["stem_mcq"]["tag"])

	

	child["answers"].each do |a|
		McqAnswer.create(
			answer: a["description"],
			correct: a["correct"],
			mcq_id: child_mcq.id
			)
	end
	child_mcq.save!
end

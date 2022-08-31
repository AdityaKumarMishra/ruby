f = File.open("./exam.json","r")

f.each_line do |line|

  read_exam = JSON.parse(f.readline)

  exam = OnlineExam.create(
      title: read_exam["title"],
  instruction: read_exam["instruction"],
  published: read_exam["published"],
      sections: []
  )

  read_exam["sections"].each do |sec|
    section = Section.create(
        title: sec["title"],
    duration: sec["duration"],
    position: sec["position"],
    sectionable_type: "OnlineExam",
        sectionable: exam
    )
    exam.sections.push section
    exam.save

    sec["questions"].each do |my_mcq|
      dif = my_mcq["stem_mcq"]["difficulty"]
      puts dif

      if dif == nil
        dif = 50
      end

      case dif
        when dif < 33
          dif = 'easy'
        when (dif >= 33) && (dif < 66)
          dif = 'medium'
        else
          dif = 'hard'
      end

      if dif.nil?
        dif = "medium"
      end

      STDOUT.print("dif main: " + dif.to_s + "\n")
      stem = McqStem.create(
          title: my_mcq["stem_mcq"]["title"],
          published: my_mcq["stem_mcq"]["published"],
          description: my_mcq["stem_mcq"]["description"],
          difficulty: dif,
          examinable: true
      )
      stem.tags = [Tag.find_or_create_by(name: my_mcq["stem_mcq"]["tag"])]

      stem.save

      my_mcq["child_mcqs"].each do |child|

        child_q = child["description"]
        child_exp = child["explanation"]
        dif_c = my_mcq["stem_mcq"]["difficulty"]
        if dif_c.nil?
          dif_c = 50
        end
        #STDOUT.print("dif child: " + dif_c.to_s)
        child_mcq = Mcq.create(
            question: child_q,
            explanation: child_exp,
            publish: my_mcq["stem_mcq"]["published"],
            examinable: true,
            rating: child["rating"],
            difficulty: dif_c,
            mcq_stem_id: stem.id
        )
        child_mcq.tag = Tag.find_or_create_by(name: my_mcq["stem_mcq"]["tag"])

        sec_item = SectionItem.create(section: section,
                                      mcq_stem: stem,
                                      mcq: child_mcq
        )

        section.section_items.push(sec_item)
        section.save!

        child["answers"].each do |a|
          McqAnswer.create(
              answer: a["description"],
              correct: a["correct"],
              mcq_id: child_mcq.id
          )
        end
        child_mcq.save!
      end
    end
    #exam.sections.push(section)
    #exam.save!
  end
end

def tag_map(input_tag)

  tag_hash = {"HUM01 Poetry" => "GM.1.1 Poetry",
              "HUM02 Fiction" => "GM.1.2 Fiction",
              "HUM03 Cartoon and comics" => "GM.1.3 Cartoon and comics",
              "HUM04 Non-fiction medical" => "GM.1.4 Non-fiction medical",
              "HUM05 Non-fiction non-medical" => "GM.1.5 Non-fiction non-medical",
              "HUM06 Charts and diagrams" => "GM.1.6 Charts and diagrams",
              "BIO01 Biomolecules & the cell" => "GM.2.1 Biomolecules & the cell",
              "BIO02 Enzymes, cellular metabolism & the central dogma" => "GM.2.2 Enzymes, cellular metabolism & the central dogma",
              "BIO03 Cell division" => "GM.2.3 Cell division",
              "BIO04 Nervous system" => "GM.2.4 Nervous system",
              "BIO05 Musculoskeletal system" => "GM.2.5 Musculoskeletal system",
              "BIO06 Cardiovascular system" => "GM.2.6 Cardiovascular system",
              "BIO07 Respiratory system" => "GM.2.7 Respiratory system",
              "BIO08 Gastrointestinal system" => "GM.2.8 Gastrointestinal system",
              "BIO09 Renal system" => "GM.2.9 Renal system",
              "BIO10 Endocrine system" => "GM.2.10 Endocrine system",
              "BIO11 Immune system" => "GM.2.11 Immune system",
              "BIO12 Genetics & Evolution" => "GM.2.12 Genetics & Evolution",
              "BIO13 Reproductive system" => "GM.2.13 Reproductive system",
              "BIO14 Experimental design and data analysis" => "GM.2.14 Experimental design and data analysis",
              "CHE01 The Atom" => "GM.3.1 The Atom",
              "CHE02 Chemical Equations and Stoichiometry" => "GM.3.2 Chemical Equations and Stoichiometry",
              "CHE03 Electrons and Chemical Bonds" => "GM.3.3 Electrons and Chemical Bonds",
              "CHE04 Gases" => "GM.3.4 Gases",
              "CHE05 Thermodynamics and kinetics" => "GM.3.5 Thermodynamics and kinetics",
              "CHE06 Acids, Bases, Buffers and Redox reactions" => "GM.3.6 Acids, Bases, Buffers and Redox reactions",
              "CHE07 Electrochemistry" => "GM.3.7 Electrochemistry",
              "CHE08 Common organic reactions" => "GM.3.8 Common organic reactions",
              "CHE09 Special organic reactions" => "GM.3.9 Special organic reactions",
              "CHE10 Stereochemistry and projections" => "GM.3.10 Stereochemistry and projections",
              "CHE11 Biochemistry" => "GM.3.11 Biochemistry",
              "CHE12 Spectroscopies and Spectrometries" => "GM.3.12 Spectroscopies and Spectrometries",
              "CHE13 Laboratory Techniques" => "GM.3.13 Laboratory Techniques",
              "PHY01 Linear Motion" => "GM.4.1 Linear Motion",
              "PHY02 Motion in 2 Dimensions" => "GM.4.2 Motion in 2 Dimensions",
              "PHY03 Newton's Laws and Types of Forces" => "GM.4.3 Newton's Laws and Types of Forces",
              "PHY04 Mechanical Equilibrium" => "GM.4.4 Mechanical Equilibrium",
              "PHY05 Work, Energy and Momentum" => "GM.4.5 Work, Energy and Momentum",
              "PHY06 Fluids, Pressure and Heat" => "GM.4.6 Fluids, Pressure and Heat",
              "PHY07 Electromagnetism" => "GM.4.7 Electromagnetism",
              "PHY08 Electrical Circuits" => "GM.4.8 Electrical Circuits",
              "PHY09 Waves and Optics" => "GM.4.9 Waves and Optics",
              "PHY10 Nuclear Physics" => "GM.4.10 Nuclear Physics"}

  tag_hash[input_tag]
end

McqStem.all.each do |m|
  if !m.nil?
    if !m.tags.nil? || (!m.tags.size == 0)
      if !m.tags.first.nil?
        if !Tag.find_by_name(tag_map(m.tags.first.name)).nil?
          m.tags.push(Tag.find_by_name(tag_map(m.tags.first.name)))
          m.save
        end
      end
    end
  end
end


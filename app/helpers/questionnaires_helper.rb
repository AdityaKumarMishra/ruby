module QuestionnairesHelper
  def univerisity_collection
    [['Australian Catholic University', 'Australian Catholic University'],
     ['Australian National University', 'Australian National University'],
     ['Bond University', 'Bond University'],
     ['Central Queensland University', 'Central Queensland University'],
     ['Charles Darwin University', 'Charles Darwin University'],
     ['Charles Sturt University', 'Charles Sturt University'],
     ['Curtin University', 'Curtin University'],
     ['Deakin University', 'Deakin University'],
     ['Edith Cowan University', 'Edith Cowan University'],
     ['Flinders University', 'Flinders University'],
     ['Griffith University', 'Griffith University'],
     ['James cookies University', 'James cookies University'],
     ['La Trobe University', 'La Trobe University'],
     ['Macquarie University', 'Macquarie University'],
     ['Monash University', 'Monash University'],
     ['Murdoch University', 'Murdoch University'],
     ['Queensland University of Technology',
      'Queensland University of Technology'],
     ['RMIT University', 'RMIT University'],
     ['Southern Cross University', 'Southern Cross University'],
     ['Swinburne University of Technology University',
      'Swinburne University of Technology University'],
     ['University of Adelaide', 'University of Adelaide'],
     ['University of Ballarat', 'University of Ballarat'],
     ['University of Canberra', 'University of Canberra'],
     ['University of Melbourne', 'University of Melbourne'],
     ['University of New England', 'University of New England'],
     ['University of New South Wales', 'University of New South Wales'],
     ['University of Newcastle', 'University of Newcastle'],
     ['University of Notre Dame', 'University of Notre Dame'],
     ['University of Queensland', 'University of Queensland'],
     ['University of South Australia', 'University of South Australia'],
     ['University of Southern Queensland', 'University of Southern Queensland'],
     ['University of Sydney', 'University of Sydney'],
     ['University of Tasmania', 'University of Tasmania'],
     ['University of Technology Sydney', 'University of Technology Sydney'],
     ['University of the Sunshine Coast', 'University of the Sunshine Coast'],
     ['University of Western Australia', 'University of Western Australia'],
     ['University of Western Sydney', 'University of Western Sydney'],
     ['University of Wollongong', 'University of Wollongong'],
     ['Victoria University', 'Victoria University'],
     %w(Other Other)]
  end

  def course_collection
    [['Bachelor of Arts', 'Bachelor of Arts'],
     ['Bachelor of Biomedicine/Medical Science',
      'Bachelor of Biomedicine/Medical Science'],
     ['Bachelor of Commerce', 'Bachelor of Commerce'],
     ['Bachelor of Nursing', 'Bachelor of Nursing'],
     ['Bachelor of Pharmacy', 'Bachelor of Pharmacy'],
     ['Bachelor of Science/Health Sciences',
      'Bachelor of Science/Health Sciences'],
     %w(Others Others)]
  end

  def source_collection
    [['Google/Search', 'Google/Search'],
     ['Word of mouth', 'Word of mouth'],
     %w(Facebook Facebook),
     ['Posters(Large A3 sheets posted on wall)',
      'Posters(Large A3 sheets posted on wall)'],
     ['Posters(A4 sheets posted on wall)', 'Posters(A4 sheets posted on wall)'],
     ['Flyers(Smaller A5 handouts)', 'Flyers(Smaller A5 handouts)'],
     %w(Brochures Brochures),
     ['In class', 'In class'],
     %w(Workshop Workshop),
     ['Through student society', 'Through student society'],
     %w(Other other)]
  end

  def last_source_collection
    [['NA', 'na'],
    %w(Brochures Brochures),
    %w(Facebook Facebook),
    ['Flyers(Smaller A5 handouts)', 'Flyers(Smaller A5 handouts)'],
    ['Google/Search', 'Google/Search'],
    ['In class', 'In class'],
    ['Posters(Large A3 sheets posted on wall)',
      'Posters(Large A3 sheets posted on wall)'],
    ['Posters(A4 sheets posted on wall)', 'Posters(A4 sheets posted on wall)'],
    ['Through student society', 'Through student society'],
    ['Word of mouth', 'Word of mouth'],
    %w(Workshop Workshop),
    %w(Other other)]
  end

  def language_collection
    [['NA', 'na'],
     ['Arabic', 'arabic'],
     ['Chinese', 'chinese'],
     ['Greek', 'greek'],
     ['Hindi', 'hindi'],
     ['Italian', 'italian'],
     ['Korean', 'korean'],
     ['Tamil', 'tamil'],
     ['Vietnamese', 'vietnamese'],
     ['Other', 'other']]
  end

  def student_collection
    [
      ['High School Student', 'highschool'],
      ['University Student', 'university'],
      ['Other', 'other']
    ]
  end

  def year_level_collection
    [['Year 10', 'year_10'],
     ['Year 11', 'year_11'],
     ['Year 12', 'year_12']]
  end

  def other_data_collection
    [['Profession/Job/Training', 'profession_job_training'],
     ['Previous University/Learning Institution', 'previous_university_learning_institution'],
     ['Year of Most Recently Completed Qualification', 'year_of_most_recently_completed_qualification']]
  end

  def student_region_collection
    [
      ['Domestic', 'domestic'],
      ['International', 'international']
    ]
  end
end

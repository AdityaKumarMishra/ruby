if User.count <= 2
  User.delete_all
  Tag.delete_all
  ProductVersion.delete_all
  Course.delete_all
  McqAnswer.delete_all
  Mcq.delete_all
  McqStem.delete_all

  # ********** USERS ********** #

  student = User.new
  staff = User.new
  tutor = User.new
  manager = User.new
  admin = User.new
  super_admin = User.new

  student.email = "student@gradready.com.au"
  staff.email = "staff@gradready.com.au"
  tutor.email = "tt@gradready.com.au"
  manager.email = "manager@gradready.com.au"
  admin.email = "admin@gradready.com.au"
  super_admin.email = "super_admin@gradready.com.au"

  student.first_name = "Student"
  staff.first_name = "Staff"
  tutor.first_name = "Tutor"
  manager.first_name = "Manager"
  admin.first_name = "Admin"
  super_admin.first_name = "Super"

  student.last_name = "Test"
  staff.last_name = "Test"
  tutor.last_name = "Test"
  manager.last_name = "Test"
  admin.last_name = "Test"
  super_admin.last_name = "Test"


  add1 = Address.create(line_one: FFaker::AddressAU::street_address, suburb: FFaker::AddressAU::suburb, post_code: FFaker::AddressAU::postcode, state: 'victoria', country: 'australia')
  add2 = Address.create(line_one: FFaker::AddressAU::street_address, suburb: FFaker::AddressAU::suburb, post_code: FFaker::AddressAU::postcode, state: 'victoria', country: 'australia')
  add3 = Address.create(line_one: FFaker::AddressAU::street_address, suburb: FFaker::AddressAU::suburb, post_code: FFaker::AddressAU::postcode, state: 'victoria', country: 'australia')
  add4 = Address.create(line_one: FFaker::AddressAU::street_address, suburb: FFaker::AddressAU::suburb, post_code: FFaker::AddressAU::postcode, state: 'victoria', country: 'australia')
  add5 = Address.create(line_one: FFaker::AddressAU::street_address, suburb: FFaker::AddressAU::suburb, post_code: FFaker::AddressAU::postcode, state: 'victoria', country: 'australia')
  add6 = Address.create(line_one: FFaker::AddressAU::street_address, suburb: FFaker::AddressAU::suburb, post_code: FFaker::AddressAU::postcode, state: 'victoria', country: 'australia')

  student.address = add1
  staff.address = add2
  tutor.address = add3
  manager.address = add4
  admin.address = add5
  super_admin.address = add6

  staff.bio = "this is a staff bio"
  tutor.bio = "this is a tutor bio"
  manager.bio = "this is a manager bio"
  admin.bio = "this is a admin bio"
  super_admin.bio = "this is a super admin bio"

  student.password = "password"
  staff.password = "password"
  tutor.password = "password"
  manager.password = "password"
  admin.password = "password"
  super_admin.password = "password"

  student.role = 0
  staff.role = 1
  tutor.role = 1
  manager.role = 2
  admin.role = 3
  super_admin.role = 4


  student.username = "student_user"
  staff.username = "staff_user"
  tutor.username = "tutor_user"
  manager.username = "manager_user"
  admin.username = "admin_user"
  super_admin.username = "super_admin_user"

  student.confirmed_at = Date.today
  staff.confirmed_at = Date.today
  tutor.confirmed_at = Date.today
  manager.confirmed_at = Date.today
  admin.confirmed_at = Date.today
  super_admin.confirmed_at = Date.today

  student.save!
  staff.save!
  tutor.save!
  manager.save!
  admin.save!
  super_admin.save!

  staff_profile1 = StaffProfile.create(staff_id: staff.id)

  # ********** TAGS ********** #

  publicT = Tag.create(id: 253, name: "PT Public", description: "General Forum for unspecified issues")
  escalationT = Tag.create(id: 343, name: "PT.05 Escalation of Issues", description: "Escalation Forum for issues", is_public: true)
  gamsatT = Tag.create(id: 246, name: "GM GAMSAT", description: "Graduate Australian Medical School Admissions Test")
  umatT = Tag.create(id: 30, name: "UM UMAT", description: "Undergraduate Medical Admissions Test")
  vengT = Tag.create(id: 37, name: "VE VCE English", description: "VCE ENGLISH")
  vmathT = Tag.create(id: 325, name: "MA Mathematics VCE", description: "VCE MATH")
  hengT = Tag.create(id: 38, name: "HE HSC English Advanced", description: "HSC MATH")
  hmathT = Tag.create(id: 326, name: "MA Mathematics HSC", description: "HSC MATH")
  irT = Tag.create(id: 324, name: "IR GAMSAT", description: "Interview Ready GAMSAT")
  irtest1T = Tag.create(id: 341, name: "Interview Test 1", description: "Interview Test 1")
  irtest2T = Tag.create(id: 342, name: "Interview Test 2", description: "Interview Test 2")

  g_human = Tag.create(name: "GM.01 Humanities", parent_id: gamsatT.id)
  g_bio = Tag.create(name: "GM.02 Biology", parent_id: gamsatT.id)
  g_chem = Tag.create(name: "GM.03 Chemistry", description: "Chemistry is the study of matter", parent_id: gamsatT.id)
  g_phy = Tag.create(name: "GM.04 Physics", parent_id: gamsatT.id)

  u_log = Tag.create(name: "UM.01 Logical Reasoning", parent_id: umatT.id)
  u_people = Tag.create(name: "UM.02 Understanding People", parent_id: umatT.id)
  u_verbal = Tag.create(name: "UM.03 Non-Verbal Reasoning", parent_id: umatT.id)

  h_area = Tag.create(name: "HE.01 Area of Study: Discovery Guide", parent_id: hengT.id)
  h_text = Tag.create(name: "HE.02 HSC Text-based study guides", parent_id: hengT.id)

  v_lang = Tag.create(name: "VE.01 VCE Language Analysis Guide", parent_id: vengT.id)
  v_text = Tag.create(name: "VE.02 VCE Text-based study guides", parent_id: vengT.id)

  ir_med = Tag.create(name: "IR.01 Medical Matters", parent_id: irT.id)
  ir_con = Tag.create(name: "IR.02 Conflict Resolution", parent_id: irT.id)
  ir_eth = Tag.create(name: "IR.03 Ethical Dilemmas", parent_id: irT.id)
  ir_cop = Tag.create(name: "IR.04 Coping with Medicine", parent_id: irT.id)

  g_gen = Tag.create(name: "GM.01.00 General", parent_id: g_human.id)
  g_poet = Tag.create(name: "GM.01.01 Poetry", parent_id: g_human.id)
  g_fic = Tag.create(name: "GM.01.02 Fiction", parent_id: g_human.id)

  g_mol = Tag.create(name: "GM.02.01 Biomolecules & the cell", parent_id: g_bio.id)
  g_cell = Tag.create(name: "GM.02.03 Cell division", parent_id: g_bio.id)
  g_nerve = Tag.create(name: "GM.02.04 Nervous system", parent_id: g_bio.id)

  # ************** PRODUCT VERSIONS ******************** #

  g_oe = ProductVersion.create(name:'Online (Essentials)',price: 454,type: 'GamsatReady', slug: "online-basic", course_type: 4 )
  g_oc = ProductVersion.create(name:'Online (Comprehensive)',price: 726,type: 'GamsatReady', slug: "online", course_type: 5 )
  g_oc = ProductVersion.create(name:'Starter',price: 726,type: 'GamsatReady', slug: 'gamsat-starter', course_type: 11 )
  g_oc = ProductVersion.create(name:'Starter',price: 726,type: 'UmatReady', course_type: 11, slug: 'umat-starter' )
  g_ae = ProductVersion.create(name:'Attendance (Essentials)',price: 908,type: 'GamsatReady', slug: "attendence-basic", course_type: 6 )
  g_ac = ProductVersion.create(name:'Attendance (Comprehensive)',price: 1226,type: 'GamsatReady', slug: "attendence-d4588d4f-d803-4a68-8b06-06c2af9406ee", course_type: 7)
  g_acc = ProductVersion.create(name:'Attendance (Comprehensive + Private Tutoring)',price: 1681,type: 'GamsatReady', slug: "attendence-all", course_type: 8)
  g_trial = ProductVersion.create(name:'GAMSAT - Free Trial',price: 0,type: 'GamsatReady', slug: "1-week-trial", course_type: 0)
  g_custom = ProductVersion.create(name:'Custom',price: 0,type: 'GamsatReady', course_type: 1)
  g_irc = ProductVersion.create(name:'InterviewReady Comprehensive',price: 726,type: 'GamsatReady', slug: "interviewready-comprehensive", course_type: 2)
  g_ire = ProductVersion.create(name:'InterviewReady Essentials',price: 363,type: 'GamsatReady', slug: "interviewready-essentials", course_type: 3)

  u_oe = ProductVersion.create(name:'Online (Essentials)',price: 295,type: 'UmatReady', slug: "online-basic-5e64c230-6be0-4d7d-948a-4338a900b0af", course_type: 4)
  u_oc = ProductVersion.create(name:'Online (Comprehensive)',price: 475,type: 'UmatReady', slug: "online-44383c37-9593-4bba-8be2-23f6f123ce15", course_type: 5 )
  u_ae = ProductVersion.create(name:'UmatReady - Attendence (Essentials)',price: 675,type: 'UmatReady', slug: "umatready-attendence-essentials", course_type: 6 )
  u_ac = ProductVersion.create(name:'Attendence (Comprehensive)',price: 845,type: 'UmatReady', slug: "attendence", course_type: 7 )
  u_acc = ProductVersion.create(name:'Attendence (Comprehensive + Private Tutoring)',price: 1295,type: 'UmatReady', slug: "attendence-all-84386da2-92e7-4267-9912-f34e31a81a59", course_type: 8 )
  u_trial = ProductVersion.create(name:'UMAT - Free Trial',price: 0,type: 'UmatReady', slug: "umat-free-trial", course_type: 0)
  u_custom = ProductVersion.create(name:'Custom',price: 0,type: 'UmatReady', slug: "custom-5905ac7d-219c-4c96-8708-7d4655ab563c", course_type: 1)

  heng_oe = ProductVersion.create(name:'English Advanced - Online (Essentials)',price: 345,type: 'HscReady', slug: "hscready-english-advanced-online-essentials" )
  heng_oc = ProductVersion.create(name:'English Advanced - Online (Comprehensive)',price: 695,type: 'HscReady', slug: "hscready-english-advanced-online-comprehensive" )
  heng_ae = ProductVersion.create(name:'English Advanced - Attendance (Essentials)',price: 795,type: 'HscReady', slug: "hscready-english-advanced-attendance-essentials" )
  heng_ac = ProductVersion.create(name:'English Advanced - Attendance (Comprehensive)',price: 1145,type: 'HscReady', slug: "hscready-english-advanced-attendance-comprehensive")
  heng_acc = ProductVersion.create(name:'English Advanced - Attendance (Comprehensive + Private Tutoring)',price: 1495,type: 'HscReady', slug: "hscready-english-advanced-attendance-comprehensive-private-tutoring")
  heng_trial = ProductVersion.create(name:'HSC English Free Trial',price: 0,type: 'HscReady', slug: "hsc-english-free-trial")
  heng_custom = ProductVersion.create(name:'English Advanced - Custom',price: 0,type: 'HscReady', slug: "english-advanced-custom")

  hmath_oe = ProductVersion.create(name:'Math Extension 1 - Online (Essentials)',price: 345,type: 'HscReady', slug: "hscready-math-extension-1-online-essentials" )
  hmath_oc = ProductVersion.create(name:'Math Extension 1 - Online (Comprehensive)',price: 495,type: 'HscReady', slug: "hscready-math-extension-1-online-comprehensive" )
  hmath_ae = ProductVersion.create(name:'Math Extension 1 - Attendance (Essentials)',price: 795,type: 'HscReady', slug: "hscready-math-extension-1-attendance-essentials" )
  hmath_ac = ProductVersion.create(name:'Math Extension 1 - Attendance (Comprehensive)',price: 945,type: 'HscReady', slug: "hscready-math-extension-1-attendance-comprehensive")
  hmath_acc = ProductVersion.create(name:'Math Extension 1 - Attendance (Comprehensive + Private Tutoring)',price: 1295,type: 'HscReady', slug: "hscready-math-extension-1-attendance-comprehensive-private-tutoring")
  hmath_trial = ProductVersion.create(name:'HSC Maths Free Trial',price: 0,type: 'HscReady', slug: "hsc-maths-free-trial")
  hmath_custom = ProductVersion.create(name:'Math Extension 1 - Custom',price: 0,type: 'HscReady', slug: "math-extension-1-cutsom")

  veng_oe = ProductVersion.create(name:'English - Online (Essentials)',price: 245,type: 'VceReady', slug: "english-advanced-online-essentials" )
  veng_oc = ProductVersion.create(name:'English - Online (Comprehensive)',price: 465,type: 'VceReady', slug: "english-advanced-online-comprehensive" )
  veng_ae = ProductVersion.create(name:'English - Attendance (Essentials)',price: 535,type: 'VceReady', slug: "english-advanced-attendance-essentials" )
  veng_ac = ProductVersion.create(name:'English - Attendance (Comprehensive)',price: 755,type: 'VceReady', slug: "english-advanced-attendance-comprehensive")
  veng_acc = ProductVersion.create(name:'English - Attendance (Comprehensive + Private Tutoring)',price: 1055,type: 'VceReady', slug: "english-advanced-attendance-comprehensive-private-tutoring")
  veng_trial = ProductVersion.create(name:'English - Custom',price: 0,type: 'VceReady', slug: "english-custom")
  veng_custom = ProductVersion.create(name:'VCE English Free Trial',price: 0,type: 'VceReady', slug: "vce-english-free-trial")

  vmath_oe = ProductVersion.create(name:'Mathematical Methods (CAS) - Online (Essentials)',price: 245,type: 'VceReady', slug: "math-extension-1-online-essentials" )
  vmath_oc = ProductVersion.create(name:'Mathematical Methods (CAS) - Online (Comprehensive)',price: 635,type: 'VceReady', slug: "math-extension-1-online-comprehensive" )
  vmath_ae = ProductVersion.create(name:'Mathematical Methods (CAS) - Attendance (Essentials)',price: 535,type: 'VceReady', slug: "math-extension-1-attendance-essentials" )
  vmath_ac = ProductVersion.create(name:'Mathematical Methods (CAS) - Attendance (Comprehensive)',price: 635,type: 'VceReady', slug: "math-extension-1-attendance-comprehensive")
  vmath_acc = ProductVersion.create(name:'Mathematical Methods (CAS) - Attendance (Comprehensive + Private Tutoring)',price: 935,type: 'VceReady', slug: "math-extension-1-attendance-comprehensive-private-tutoring")
  vmath_trial = ProductVersion.create(name:'VCE Maths Free Trial',price: 0,type: 'VceReady', slug: "vce-maths-free-trial")
  vmath_custom = ProductVersion.create(name:'Mathematical Methods (CAS) - Custom',price: 0,type: 'VceReady', slug: "mathematical-methods-cas-custom")

  # ************** COURSES ******************** #

  cities = ['Adelaide', 'Melbourne', 'Sydney', 'Brisbane', 'Perth']
  ProductVersion.all.each do |pv|
    cities.each do |city|
      Course.create(name: (pv.type.split("Ready").first + ' - ' + city + ' - ' + (Date.today.year + 1).to_s + ' - ' + pv.name),class_size: 18,expiry_date: Date.today.next_month,enrolment_end_date: Date.today.next_week,product_version_id: pv.id,city: city, is_active: true, staff_profile_ids: [staff_profile1.id])
    end
  end

  # ******* ENROL STUDENT INTO GAMSAT ONLINE ESSENTIAL COURSE *********** #

  enrol1 = Enrolment.create(course_id: Course.first.id)
  order1 = Order.create(user_id: student.id, creator_id: student.id, status: :free,purchase_method: :paypal)

  p_item1 = enrol1.create_purchase_item(initial_cost: Course.first.price, user_id: student.id,shipping_cost: 0, purchase_description: Course.first.product_version.name + ' ' + Course.first.product_version.type, order_id: order1.id)


  # ************** MASTER FEATURES ******************** #

  document_feature = MasterFeature.create(name: "GamsatDocumentsFeature", title: "Documents", url: "documents_path", icon: "fa fa-folder", show_in_sidebar: true,
    position: 10, types: ["GamsatReady"])

  mcq_feature = MasterFeature.create(name: "GamsatMcqFeature", title: "MCQs", url: "new_exercise_path", icon: "fa fa-plus-square", show_in_sidebar: true,
    position: 2, types: ["GamsatReady"])

  vdo_feature = MasterFeature.create(name: "GamsatVideoFeature", title: "Videos", url: "vods_path", icon: "fa fa-video-camera", show_in_sidebar: true,
    position: 5, types: ["GamsatReady"])

  textbook_feature = MasterFeature.create(name: "GamsatTextbookFeature", title: "Textbooks", url: "dashboard_textbooks_path", icon: "fa fa-book", show_in_sidebar: true, position: 6, types: ["GamsatReady"])

  essay_feature = MasterFeature.create(name: "GamsatEssayFeature", title: "My essays", url: "essay_responses_path", icon: "fa fa-pencil", show_in_sidebar: true, position: 3, types: ["GamsatReady"])

  exam_feature = MasterFeature.create(name: "GamsatExamFeature", title: "Exams", url: "online_exam_attempts_path", icon: "fa fa-tag", show_in_sidebar: true, position: 7, types: ["GamsatReady"])

  clarity_feature = MasterFeature.create(name: "GamsatGetClarityFeature", title: "GetClarity", url: "dashboard_unresolved_issues_path", icon: "fa fa-eye", show_in_sidebar: true, position: 8, types: ["GamsatReady"])

  diagnostics_feature = MasterFeature.create(name: "GamsatDiagnosticsFeature", title: "Diagnostics Assessment", url: "diagnostic_test_attempts_path", icon: "fa fa-tag", show_in_sidebar: true, position: 1, types: ["GamsatReady"])


  default_master_features = [document_feature, mcq_feature, vdo_feature, essay_feature, exam_feature, diagnostics_feature]

  additional_master_features = [textbook_feature, clarity_feature]

  # ************** PRODUCT VERSION FEATURE PRICES ******************** #

  ProductVersion.all.each do |pv|
    default_master_features.each do |m|
      ProductVersionFeaturePrice.create(product_version_id: pv.id, master_feature_id: m.id, is_default: true, is_additional: false, price: 0, tag_ids: [246])
    end
  end

  ProductVersion.all.each do |pv|
    additional_master_features.each do |m|
      ProductVersionFeaturePrice.create(product_version_id: pv.id, master_feature_id: m.id, is_default: false, is_additional: false, price: 0, tag_ids: [246])
    end
  end

  # ************** FEATURE LOGS ******************** #

  ProductVersionFeaturePrice.all.each do |pvfp|
    FeatureLog.create(description: "description", qty: 1,product_version_feature_price: pvfp, enrolment: enrol1, acquired: Date.today)
  end

  # ************** ESSAYS ******************** #

  essay1 = Essay.create(title: "Gamsat Essay 1", question: "Gamsat Essay", tutor_id: tutor.id, tag_ids: [gamsatT.id])
  essay2 = Essay.create(title: "Umat Essay 1", question: " Essay", tutor_id: tutor.id, tag_ids: [umatT.id])

  # ******* MCQ STEMS WITH MCQS ****** #

  stem1 = McqStem.create(title: 'MCQ Stem Test 1', description: 'Description of the first MCQ Stem', author_id: admin.id, reviewer_id: admin.id, difficulty: 50, reviewed: true, published: true, tag_ids: [g_chem.id])
  st1_q1 = Mcq.create(question: 'st1_question 1 this is a question?',difficulty: 50,examinable: false,publish: true ,mcq_stem_id: stem1.id,explanation: 'explanation of stem1 q1', tag: g_chem)

  for i in (1..4)
    x = McqAnswer.create(answer: ('answer number ' + i.to_s),mcq_id:st1_q1.id)
    if (rand(4) +1) == i
      x.correct = true
    else
      x.correct = false
    end

    x.save!
  end

  st1_q2 = Mcq.create(question: 'st1_question 2 this is a question?',difficulty: 70,examinable: false,publish: true,mcq_stem_id: stem1.id,explanation: 'explanation of stem1 q2', tag: g_chem)

  for i in (1..4)
    x = McqAnswer.create(answer: ('answer number ' + i.to_s),mcq_id:st1_q2.id)
    if (rand(4) +1) == i
      x.correct = true
    else
      x.correct = false
    end
    x.save!
  end


  exam_stem1 = McqStem.create(title: 'Exam MCQ Stem 1', description: 'Description of the first MCQ Stem', author_id: admin.id, reviewer_id: admin.id, difficulty: 50, reviewed: true, published: true, examinable: true, tag_ids: [g_chem.id])
  exam_mcq1 = Mcq.create(question: 'this is first exam mcq question?',difficulty: 50,examinable: true,publish: true ,mcq_stem_id: exam_stem1.id,explanation: 'explanation of stem1 q1', tag: g_chem)

  for i in (1..4)
    x = McqAnswer.create(answer: ('answer number ' + i.to_s),mcq_id:exam_mcq1.id)
    if (rand(4) +1) == i
      x.correct = true
    else
      x.correct = false
    end

    x.save!
  end

  exam_mcq2 = Mcq.create(question: 'this is second exam mcq question?',difficulty: 70,examinable: true,publish: true,mcq_stem_id: exam_stem1.id,explanation: 'explanation of stem1 q2', tag: g_chem)

  for i in (1..4)
    x = McqAnswer.create(answer: ('answer number ' + i.to_s),mcq_id:exam_mcq2.id)
    if (rand(4) +1) == i
      x.correct = true
    else
      x.correct = false
    end
    x.save!
  end

  exam_stem2 = McqStem.create(title: 'Exam MCQ Stem 2', description: 'Description of the second MCQ Stem', author_id: admin.id, reviewer_id: admin.id, difficulty: 50, reviewed: true, published: true, examinable: true, tag_ids: [g_chem.id])
  exam_mcq3 = Mcq.create(question: 'this is third exam mcq question?',difficulty: 50,examinable: true,publish: true ,mcq_stem_id: exam_stem2.id,explanation: 'explanation of stem1 q3', tag: g_chem)

  for i in (1..4)
    x = McqAnswer.create(answer: ('answer number ' + i.to_s),mcq_id:exam_mcq3.id)
    if (rand(4) +1) == i
      x.correct = true
    else
      x.correct = false
    end

    x.save!
  end

  exam_mcq4 = Mcq.create(question: 'this is fourth exam mcq question?',difficulty: 70,examinable: true,publish: true,mcq_stem_id: exam_stem2.id,explanation: 'explanation of stem1 q4', tag: g_chem)

  for i in (1..4)
    x = McqAnswer.create(answer: ('answer number ' + i.to_s),mcq_id:exam_mcq4.id)
    if (rand(4) +1) == i
      x.correct = true
    else
      x.correct = false
    end
    x.save!
  end

  # ************** ONLINE EXAMS ******************** #

  ol1 = OnlineExam.create(title: "Exam 1", instruction: "Exam Test Instructions", tag_ids: [gamsatT.id])
  section1 = Section.create(title: "Section 1", duration: 90, position: 5, sectionable_id: ol1.id, sectionable_type: "OnlineExam")

  ol1.update(published: true)


  SectionItem.create(mcq_stem: exam_stem1, mcq_id: exam_mcq1.id,section: section1)
  SectionItem.create(mcq_stem: exam_stem1, mcq_id: exam_mcq2.id,section: section1)

  # **********  DIAGNOSTIC TEST *************** #

  dt1 = DiagnosticTest.create(title: "Test 1", instruction: "Test Instructions", tag_ids: [gamsatT.id], published: true)

  section2 = Section.create(title: "Section 2", duration: 90, position: 4, sectionable_id: dt1.id, sectionable_type: "DiagnosticTest")

  SectionItem.create(mcq_stem: exam_stem1, mcq_id: exam_mcq1.id,section: section2)
  SectionItem.create(mcq_stem: exam_stem1, mcq_id: exam_mcq2.id,section: section2)

  # **********  TEXTBOOK AND DOCUMENT *************** #

  file = File.open "#{Rails.root.join('public/test.pdf')}"
  textbook1 = Textbook.create(title: "test1", document: file, tag_ids: [gamsatT.id])
  document1 = Document.create(attachment: file, accessible: true, tag_ids: [gamsatT.id], user_id: admin.id, only_dummy: false)

  #******* DISCOUNT CODES ************#

  code1 = Promo.create(token: "aBcDeF1c2", amount: 12, expiry_date: Date.today + 7.days, used_times: 3, user_id: super_admin.id)

  #******* BLOG CATEGORY ************#

  gam_cat = BlogCategory.create(name: "Gamsat Blogs", blog_type: 0)
  um_cat = BlogCategory.create(name: "Gamsat Blogs", blog_type: 1)
  vce_cat = BlogCategory.create(name: "Gamsat Blogs", blog_type: 2)
  hsc_cat = BlogCategory.create(name: "Gamsat Blogs", blog_type: 3)

  #******* BLOG ************#

  gam_post = Post.create(name: "Gamsat Test Blog", blog_type: 0, description: "This is a Gamsat Test Blog Example")
  um_post = Post.create(name: "Umat Test Blog", blog_type: 1, description: "This is a Umat Test Blog Example")
  vce_post = Post.create(name: "Vce Test Blog", blog_type: 2, description: "This is a Vce Test Blog Example")
  hsc_post = Post.create(name: "Hsc Test Blog", blog_type: 3, description: "This is a Hsc Test Blog Example")

  #******* ANNOUNCEMENT ************#

  dash_announce = Announcement.create(name: "GamsatReady-dashboard", description: "This is a Test Announcement", category: "Dashboardpage")

  #****** STUDENT ISSSUE ********#

  issue1 = Ticket.create(title: "Test Ticket", question: "Test ticket question ?", asker_id: student.id, answerer_id: tutor.id, tag_ids: [gamsatT.id])


  issue2 = Ticket.create(title: "Test 2 Ticket", question: "Test ticket question 2 ?", asker_id: student.id, answerer_id: staff.id, tag_ids: [umatT.id])

  #******* MAINLING LIST ************#

  MailingList.find_or_create_by!(name: "blog_umat")
  MailingList.find_or_create_by!(name: "blog_gamsat")
  MailingList.find_or_create_by!(name: "blog_vce")
  MailingList.find_or_create_by!(name: "blog_hsc")

  #******* RUN RAKE TASKS *************#

  Rake::Task['faq_topic:add_vce_hsc_topic'].invoke

  #********** Sign Up New Flow **********#
  AdminControl.find_or_create_by(name: 'Signup view')
end


## podcasts##
podcast = Podcast.new(slug: "GAMSAT-Section-1-Advice", title: "EP.07: GAMSAT Section 1 Advice" , uploaded_on: "December 01, 2021".to_date, duration: "46:27", ep_desc: "<p>Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for GAMSAT section 1 advice and best practices.</p>",full_desc: "<p>Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for GAMSAT section 1 advice and best practices.</p>",frame_url: "https://anchor.fm/gamsat-to-medschool/embed/episodes/EP-07-GAMSAT-Section-1-Advice-e1b2kkf", video_url: "https://gradready-prod.s3.ap-southeast-2.amazonaws.com/video/mp4_hd/EP.07.mp4" , video_name: "Podcast 7 - Thumbnail.png" ,title_tag: "GAMSAT Podcast EP.07: GAMSAT Section 1 Advice",meta_description: "Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for GAMSAT section 1 advice and best practices." , image: URI.parse("https://stage1.gradready.com.au/assets/podcast/EP.07.png").open)

podcast.save

podcast = Podcast.new(slug: "how-hard-is-the-gamsat", title: "EP.08: How Hard Is The GAMSAT" , uploaded_on: "December 01, 2021".to_date, duration: "04:52", ep_desc: "<p>Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for the GAMSAT exam and explain best techniques to manage the exam.</p>",full_desc: "<p>Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for the GAMSAT exam and explain best techniques to manage the exam.</p>",frame_url: "https://anchor.fm/gamsat-to-medschool/embed/episodes/EP-08-How-Hard-Is-The-GAMSAT-e1b2ko", video_url: "https://gradready-prod.s3.ap-southeast-2.amazonaws.com/video/mp4_hd/EP.08.mp4" , video_name: "Podcast 8 - Thumbnail.png" ,title_tag: "GAMSAT Podcast EP.08: How Hard Is The GAMSAT",meta_description: "Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for the GAMSAT exam and explain best techniques to manage the exam." , image: URI.parse("https://stage1.gradready.com.au/assets/podcast/EP.08.png").open)

podcast.save

podcast = Podcast.new(slug: "how-to-prepare-for-medical-school-interviews", title: "EP.09: How to prepare for medical school interviews" , uploaded_on: "December 01, 2021".to_date, duration: "47:30", ep_desc: "<p>Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for medical school interviews and breakdown high yield techniques to excel.</p>",full_desc: "<p>Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for medical school interviews and breakdown high yield techniques to excel.</p>",frame_url: "https://anchor.fm/gamsat-to-medschool/embed/episodes/EP-09-How-to-prepare-for-medical-school-interviews-e1b2l12", video_url: "https://gradready-prod.s3.ap-southeast-2.amazonaws.com/video/mp4_hd/EP.09.mp4" , video_name: "Podcast 9 - Thumbnail.png" ,title_tag: "GAMSAT Podcast EP.09: How to prepare for medical school interviews",meta_description: "Join Nick and Felicity in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about best practices for medical school interviews and breakdown high yield techniques to excel." , image: URI.parse("https://stage1.gradready.com.au/assets/podcast/EP.09.png").open)

podcast.save

podcast = Podcast.new(slug: "gamsat-section-2-advice-and-best-practices", title: "EP.10: GAMSAT Section 2 Advice and Best Practices" , uploaded_on: "December 01, 2021".to_date, duration: "52:14", ep_desc: "<p>Join Nick and Caroline in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about GAMSAT Section 2, provide expert advice and discuss best preparation practices.</p>",full_desc: "<p>Join Nick and Caroline in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about GAMSAT Section 2, provide expert advice and discuss best preparation practices.</p>",frame_url: "https://anchor.fm/gamsat-to-medschool/embed/episodes/EP-10-GAMSAT-Section-2-Advice-and-Best-Practices-e1b2lao", video_url: "https://gradready-prod.s3.ap-southeast-2.amazonaws.com/video/mp4_hd/EP.10.mp4" , video_name: "Podcast 10 - Thumbnail.png" ,title_tag: "GAMSAT Podcast EP.10: GAMSAT Section 2 Advice and Best Practices",meta_description: "Join Nick and Caroline in the seventh episode of GradReady's GAMSAT to Med School Podcast as they talk about GAMSAT Section 2, provide expert advice and discuss best preparation practices." , image: URI.parse("https://stage1.gradready.com.au/assets/podcast/EP.10.png").open)

podcast.save
podcast = Podcast.new(slug: "Best-Practices-for-Resitting-the-GAMSAT", title: "EP.13: Best Practices for Resitting the GAMSAT" , uploaded_on: "June 9, 2022".to_date, duration: "41:48", ep_desc: "<p>Join Kayley and Siena in the thirteenth episode of GradReady's GAMSAT to Med School Podcast as they talk about the best practices for resitting the GAMSAT.</p>",full_desc: "<p>Join Kayley and Siena in the thirteenth episode of GradReady's GAMSAT to Med School Podcast as they talk about the best practices for resitting the GAMSAT.</p>",frame_url: "https://anchor.fm/gamsat-to-medschool/embed/episodes/Episode-13-Best-Practices-for-Resitting-the-GAMSAT-e1jnivh/a-a833lio", video_url: "https://gradready.s3.ap-southeast-2.amazonaws.com/vods/videos/000/000/011/Original/Podcast+13+Full+-+Best+Practices+for+Resitting+the+GAMSAT.mp4" , video_name: "Podcast 13 - Thumbnail.png" ,title_tag: "EEP.13: Best Practices for Resitting the GAMSAT",meta_description: "Join Kayley and Siena in the thirteenth episode of GradReady's GAMSAT to Med School Podcast as they talk about the best practices for resitting the GAMSAT." , image: URI.parse("https://gradready.s3.ap-southeast-2.amazonaws.com/podcasts/images/000/000/011/podcast+index+page/13.png").open)
podcast.save

tag_names = ["GM - Compare and Contrast","GM - Deduction Inferences and Generalisation","GM - Visualisation and Pattern Perception","GM - Data Interpretation Extrapolation and Interpolation","GM - Calculation and Estimation","UC - VR - Speed Reading","UC - VR - Keyword Scanning","UC - VR - Contradictory Information ","UC - VR - Prior Knowledge","UC - VR - Assumptions","UC - VR - Causation vs Correlation","UC - VR - Synonyms","UC - VR - Numerical Reasoning","UC - VR - Date Identification","UC - DM - Venn Diagrams","UC - DM - Inferences","UC - DM - Probabilistic Reasoning","UC - AR - Shape","UC - AR - Colour","UC - AR - Arrangement","UC - AR - Number","UC - AR - Symmetry","UC - AR - Conditional Patterns","UC - AR - Complex","UC - QR - Mental Calculations","UC - QR - Basic Arithmetic","UC - QR - Estimation Skills","UC - QR - Time Management","UC - QR - Efficiency (Looking for quickest method)","UC - QR - Numerical Precision","UC - QR - Calculator/Numpad Familiarity","UC - QR - Complex","UC - SJ - NIL"]
tag_names.each do |tag_name|
  SkillTag.new(tag_name: tag_name).save!
end

skill_tag_zero = SkillTag.find_by(tag_name: "GM - Compare and Contrast")
skill_tag_one = SkillTag.find_by(tag_name: "GM - Deduction Inferences and Generalisation")
skill_tag_two = SkillTag.find_by(tag_name: "GM - Visualisation and Pattern Perception")
skill_tag_three = SkillTag.find_by(tag_name: "GM - Data Interpretation Extrapolation and Interpolation")
skill_tag_four = SkillTag.find_by(tag_name: "GM - Calculation and Estimation")

Mcq.where("skill_tags = 0").update_all(skill_tag_id: skill_tag_zero.id)
Mcq.where("skill_tags = 1").update_all(skill_tag_id: skill_tag_one.id)
Mcq.where("skill_tags = 2").update_all(skill_tag_id: skill_tag_two.id)
Mcq.where("skill_tags = 3").update_all(skill_tag_id: skill_tag_three.id)
Mcq.where("skill_tags = 4").update_all(skill_tag_id: skill_tag_four.id)

McqStem.update_all(similarity_score: 0)
Mcq.update_all(similarity_score: 0)

McqStem.where(work_status: 11).update_all(work_status: 14)

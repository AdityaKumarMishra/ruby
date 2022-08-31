# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181221052247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "intarray"

  create_table "access_documents", force: :cascade do |t|
    t.datetime "last_accessed"
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "access_documents", ["document_id"], name: "index_access_documents_on_document_id", using: :btree
  add_index "access_documents", ["user_id"], name: "index_access_documents_on_user_id", using: :btree

  create_table "active_subjects", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "course_version_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "active_subjects", ["course_version_id"], name: "index_active_subjects_on_course_version_id", using: :btree
  add_index "active_subjects", ["subject_id"], name: "index_active_subjects_on_subject_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "number"
    t.string   "street_name"
    t.string   "street_type"
    t.string   "suburb"
    t.string   "city"
    t.string   "post_code"
    t.integer  "addresable_id"
    t.string   "addresable_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "line_one"
    t.text     "line_two"
    t.integer  "state",           default: 1, null: false
    t.integer  "country",         default: 1, null: false
  end

  create_table "admin_controls", force: :cascade do |t|
    t.string   "name"
    t.boolean  "new_view"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.string   "name",                              null: false
    t.text     "description"
    t.string   "category"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "url"
    t.integer  "product_version_id"
    t.text     "highlighted_text"
    t.boolean  "show_highlight",     default: true
    t.integer  "master_feature_id"
    t.integer  "product_line_id"
    t.text     "story"
    t.string   "display_name"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
  end

  add_index "announcements", ["name"], name: "index_announcements_on_name", unique: true, using: :btree
  add_index "announcements", ["product_line_id", "master_feature_id"], name: "index_announcements_on_product_line_id_and_master_feature_id", unique: true, using: :btree

  create_table "answer_options", force: :cascade do |t|
    t.integer  "application_question_id"
    t.string   "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "application_answers", force: :cascade do |t|
    t.integer  "job_application_id"
    t.integer  "application_question_id"
    t.text     "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "content_tag"
  end

  create_table "application_attachments", force: :cascade do |t|
    t.integer  "job_application_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "application_questions", force: :cascade do |t|
    t.integer  "job_application_form_id"
    t.text     "content"
    t.integer  "answer_type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "student_id"
    t.integer  "tutor_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "tutor_availability_id"
    t.text     "location"
    t.integer  "status",                default: 0,     null: false
    t.integer  "feature_log_id"
    t.integer  "hours"
    t.text     "content"
    t.date     "finish_date"
    t.boolean  "escalated",             default: false
  end

  add_index "appointments", ["student_id"], name: "index_appointments_on_student_id", using: :btree
  add_index "appointments", ["tutor_availability_id"], name: "index_appointments_on_tutor_availability_id", using: :btree
  add_index "appointments", ["tutor_id"], name: "index_appointments_on_tutor_id", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string   "city"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "institution_name"
  end

  add_index "areas", ["city"], name: "index_areas_on_city", using: :btree

  create_table "assessment_attempts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assessable_id"
    t.string   "assessable_type"
    t.float    "percentile"
    t.integer  "mark"
    t.datetime "completed_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "question_style",      default: 0
    t.string   "timer_option_type"
    t.integer  "course_id"
    t.integer  "attempt_mode"
    t.integer  "section_one_score",   default: 0
    t.integer  "section_three_score", default: 0
    t.string   "section_type"
    t.integer  "total_score",         default: 0
  end

  add_index "assessment_attempts", ["assessable_type", "assessable_id"], name: "index_assessment_attempts_on_assessable_type_and_assessable_id", using: :btree
  add_index "assessment_attempts", ["user_id"], name: "index_assessment_attempts_on_user_id", using: :btree

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "avg",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "blog_type"
    t.string   "slug"
  end

  add_index "blog_categories", ["slug"], name: "index_blog_categories_on_slug", using: :btree

  create_table "blog_categories_posts", force: :cascade do |t|
    t.integer "blog_category_id"
    t.integer "post_id"
  end

  add_index "blog_categories_posts", ["blog_category_id"], name: "index_blog_categories_posts_on_blog_category_id", using: :btree
  add_index "blog_categories_posts", ["post_id"], name: "index_blog_categories_posts_on_post_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "enquiry_user_id"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "common_contents", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "contact_number"
    t.date     "mock_exam_overdue"
  end

  create_table "commontator_comments", force: :cascade do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
  add_index "commontator_comments", ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at", using: :btree

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree

  create_table "commontator_threads", force: :cascade do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree

  create_table "completed_textbooks", force: :cascade do |t|
    t.integer  "textbook_id"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "completed_textbooks", ["textbook_id"], name: "index_completed_textbooks_on_textbook_id", using: :btree
  add_index "completed_textbooks", ["user_id"], name: "index_completed_textbooks_on_user_id", using: :btree

  create_table "contact_forms", force: :cascade do |t|
    t.string   "email"
    t.string   "phone"
    t.string   "subject"
    t.text     "message"
    t.integer  "contact_location_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "contact_forms", ["contact_location_id"], name: "index_contact_forms_on_contact_location_id", using: :btree

  create_table "contact_locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "position"
    t.string   "email"
    t.boolean  "visible"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "contact_location_id"
  end

  add_index "contacts", ["contact_location_id"], name: "index_contacts_on_contact_location_id", using: :btree

  create_table "countdown_timers", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.date     "end_date"
    t.time     "end_time"
    t.integer  "page_type"
    t.string   "destination_link"
    t.boolean  "active",           default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "course_addresses", force: :cascade do |t|
    t.integer  "number"
    t.string   "street_name"
    t.string   "street_type"
    t.string   "subburb"
    t.string   "post_code"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "city"
    t.string   "institution_name"
  end

  create_table "course_recommender_usages", force: :cascade do |t|
    t.integer  "incomplete",   default: 0
    t.integer  "skip",         default: 0
    t.integer  "complete",     default: 0
    t.string   "course_name"
    t.string   "product_line"
    t.string   "subject"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "course_staffs", force: :cascade do |t|
    t.integer  "staff_profile_id"
    t.integer  "course_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "course_staffs", ["course_id"], name: "index_course_staffs_on_course_id", using: :btree
  add_index "course_staffs", ["staff_profile_id"], name: "index_course_staffs_on_staff_profile_id", using: :btree

  create_table "course_versions", force: :cascade do |t|
    t.integer  "version_number"
    t.datetime "date_added"
    t.integer  "class_size"
    t.date     "expiry_date"
    t.datetime "enrolment_end_added"
    t.integer  "students_count"
    t.integer  "course_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_user_version"
    t.integer  "course_address_id"
  end

  add_index "course_versions", ["course_address_id"], name: "index_course_versions_on_course_address_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.integer  "class_size"
    t.date     "expiry_date"
    t.datetime "enrolment_end_date"
    t.integer  "product_version_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "slug",                                 null: false
    t.boolean  "is_active"
    t.integer  "essay_time",           default: 120
    t.integer  "mcq_quantity"
    t.boolean  "trial_enabled",        default: false
    t.integer  "trial_period_days",    default: 0
    t.integer  "city",                 default: 11,    null: false
    t.boolean  "show_archived",        default: false
    t.boolean  "visible_to_student",   default: false
    t.boolean  "notify_student",       default: false
    t.date     "essay_exp_start_date"
  end

  add_index "courses", ["slug"], name: "index_courses_on_slug", unique: true, using: :btree

  create_table "cover_letters", force: :cascade do |t|
    t.integer  "job_application_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "degrees", force: :cascade do |t|
    t.string   "name"
    t.string   "alternate_name",   default: [],              array: true
    t.float    "atar"
    t.string   "application_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "diagnostic_tests", force: :cascade do |t|
    t.string   "title"
    t.text     "instruction"
    t.boolean  "published"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "is_finish",   default: false
    t.boolean  "show_stat",   default: false
    t.boolean  "locked",      default: false
  end

  create_table "documents", force: :cascade do |t|
    t.boolean  "accessible"
    t.boolean  "allow_dummy"
    t.boolean  "only_dummy"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.boolean  "for_timetable"
    t.integer  "product_line_id"
    t.boolean  "for_paid"
    t.boolean  "for_trial"
  end

  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "enquiry_users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "phone_number"
    t.text     "question_tags", default: [],              array: true
  end

  create_table "enrolments", force: :cascade do |t|
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "course_id"
    t.string   "paypal_payment"
    t.string   "paypal_token"
    t.datetime "paid_at"
    t.string   "promo"
    t.string   "banktrans"
    t.float    "subtotal"
    t.float    "gst"
    t.float    "paypal_fee"
    t.boolean  "trial",                       default: false, null: false
    t.datetime "trial_expiry"
    t.integer  "state",                       default: 0
    t.boolean  "online_textbook"
    t.boolean  "hardcopy"
    t.integer  "signin_count_enrolment",      default: 0
    t.integer  "total_online_time_enrolment", default: 0
    t.integer  "expire_signin_count",         default: 0
    t.integer  "expire_total_online_time",    default: 0
  end

  add_index "enrolments", ["course_id"], name: "index_enrolments_on_course_id", using: :btree

  create_table "essay_responses", force: :cascade do |t|
    t.text     "response"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "essay_id"
    t.string   "slug"
    t.date     "activation_date"
    t.date     "expiry_date"
    t.datetime "time_submited"
    t.integer  "elapsed_time",    limit: 8, default: 0
    t.integer  "status",                    default: 0
    t.integer  "course_id"
    t.integer  "tutor_id"
    t.integer  "old_tutor_id"
  end

  add_index "essay_responses", ["essay_id"], name: "index_essay_responses_on_essay_id", using: :btree
  add_index "essay_responses", ["slug"], name: "index_essay_responses_on_slug", unique: true, using: :btree
  add_index "essay_responses", ["user_id"], name: "index_essay_responses_on_user_id", using: :btree

  create_table "essay_tutor_feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "rating"
    t.text     "response"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "essay_response_id"
  end

  add_index "essay_tutor_feedbacks", ["essay_response_id"], name: "index_essay_tutor_feedbacks_on_essay_response_id", using: :btree
  add_index "essay_tutor_feedbacks", ["user_id"], name: "index_essay_tutor_feedbacks_on_user_id", using: :btree

  create_table "essay_tutor_responses", force: :cascade do |t|
    t.text     "response"
    t.decimal  "rating",            precision: 10, scale: 2
    t.integer  "essay_response_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "staff_profile_id"
    t.integer  "elapsed_time",                               default: 0, null: false
  end

  add_index "essay_tutor_responses", ["essay_response_id"], name: "index_essay_tutor_responses_on_essay_response_id", using: :btree

  create_table "essays", force: :cascade do |t|
    t.string   "title"
    t.text     "question"
    t.datetime "date_added"
    t.integer  "tutor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "exam_id"
    t.string   "slug"
  end

  add_index "essays", ["exam_id"], name: "index_essays_on_exam_id", using: :btree
  add_index "essays", ["slug"], name: "index_essays_on_slug", unique: true, using: :btree
  add_index "essays", ["tutor_id"], name: "index_essays_on_tutor_id", using: :btree

  create_table "event_dates", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "title"
    t.date     "event_start_date"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
    t.text     "description"
    t.integer  "product_version_id"
    t.string   "product_line"
  end

  create_table "exam_sections", force: :cascade do |t|
    t.string   "title"
    t.float    "dificultyRating"
    t.integer  "exam_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
  end

  add_index "exam_sections", ["exam_id"], name: "index_exam_sections_on_exam_id", using: :btree
  add_index "exam_sections", ["slug"], name: "index_exam_sections_on_slug", unique: true, using: :btree

  create_table "exam_statistics", force: :cascade do |t|
    t.integer  "total",              default: 0
    t.integer  "incorrect",          default: 0
    t.integer  "correct",            default: 0
    t.integer  "not_attempted",      default: 0
    t.integer  "time_taken"
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "course_id"
    t.integer  "section_attempt_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "exams", force: :cascade do |t|
    t.datetime "date_started"
    t.datetime "date_finished"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "subject_id"
    t.string   "type"
    t.string   "slug"
  end

  add_index "exams", ["date_finished"], name: "index_exams_on_date_finished", using: :btree
  add_index "exams", ["date_started"], name: "index_exams_on_date_started", using: :btree
  add_index "exams", ["slug"], name: "index_exams_on_slug", unique: true, using: :btree
  add_index "exams", ["subject_id"], name: "index_exams_on_subject_id", using: :btree

  create_table "excluded_tags_staff_profiles", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "staff_profile_id"
  end

  add_index "excluded_tags_staff_profiles", ["staff_profile_id"], name: "index_excluded_tags_staff_profiles_on_staff_profile_id", using: :btree
  add_index "excluded_tags_staff_profiles", ["tag_id"], name: "index_excluded_tags_staff_profiles_on_tag_id", using: :btree

  create_table "excluded_tags_tutor_profiles", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "tutor_profile_id"
  end

  add_index "excluded_tags_tutor_profiles", ["tag_id"], name: "index_excluded_tags_tutor_profiles_on_tag_id", using: :btree
  add_index "excluded_tags_tutor_profiles", ["tutor_profile_id"], name: "index_excluded_tags_tutor_profiles_on_tutor_profile_id", using: :btree

  create_table "exercises", force: :cascade do |t|
    t.integer  "difficulty"
    t.integer  "amount"
    t.datetime "completed_at"
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.boolean  "is_deleted",        default: false,      null: false
    t.string   "timer_option",      default: "no_timer"
    t.integer  "overall_time"
    t.integer  "question_style",    default: 0
    t.string   "timer_option_type"
    t.integer  "course_id"
  end

  add_index "exercises", ["user_id"], name: "index_exercises_on_user_id", using: :btree

  create_table "exit_pop_ups", force: :cascade do |t|
    t.string   "display_name"
    t.text     "message"
    t.boolean  "visible_to_user",            default: false
    t.string   "btn_text",        limit: 20
    t.string   "btn_url"
    t.string   "category"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "popup_frequency",            default: 0
    t.string   "cookie_name"
  end

  create_table "faq_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "faq_pages", force: :cascade do |t|
    t.integer  "faq_topic_id"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "faq_pages", ["faq_topic_id"], name: "index_faq_pages_on_faq_topic_id", using: :btree

  create_table "faq_topics", force: :cascade do |t|
    t.integer  "faq_type"
    t.string   "code"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  add_index "faq_topics", ["slug"], name: "index_faq_topics_on_slug", unique: true, using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "question"
    t.string   "answer"
    t.boolean  "is_published"
    t.integer  "faq_category_id"
    t.integer  "course_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "faqs", ["course_id"], name: "index_faqs_on_course_id", using: :btree
  add_index "faqs", ["faq_category_id"], name: "index_faqs_on_faq_category_id", using: :btree

  create_table "feature_logs", force: :cascade do |t|
    t.datetime "acquired"
    t.datetime "suspended"
    t.integer  "qty"
    t.text     "description"
    t.integer  "product_version_feature_price_id"
    t.integer  "enrolment_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "exam_name"
  end

  add_index "feature_logs", ["enrolment_id"], name: "index_feature_logs_on_enrolment_id", using: :btree
  add_index "feature_logs", ["product_version_feature_price_id"], name: "index_feature_logs_on_product_version_feature_price_id", using: :btree

  create_table "features", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",              precision: 8, scale: 2
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "is_default"
    t.integer  "product_version_id"
    t.integer  "tutor_time"
    t.integer  "essay_num"
  end

  create_table "features_instructions", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "content"
    t.integer  "product_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "features_instructions", ["product_type_id"], name: "index_features_instructions_on_product_type_id", using: :btree

  create_table "features_product_versions", id: false, force: :cascade do |t|
    t.integer "product_version_id", null: false
    t.integer "feature_id",         null: false
  end

  create_table "featurettes", force: :cascade do |t|
    t.string   "options",                              default: "{}"
    t.decimal  "initial_cost", precision: 8, scale: 2
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "description"
  end

  create_table "free_study_buddies", force: :cascade do |t|
    t.string   "title"
    t.string   "button_text"
    t.string   "description"
    t.boolean  "active",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "info_text"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "high_schools", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "invoice_date"
    t.datetime "date_ordered"
    t.datetime "date_billed"
    t.datetime "date_shipment"
    t.integer  "payment_method"
    t.decimal  "total_amount",              precision: 8, scale: 2
    t.decimal  "gst_total_amount",          precision: 8, scale: 2
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "invoice_file_file_name"
    t.string   "invoice_file_content_type"
    t.integer  "invoice_file_file_size"
    t.datetime "invoice_file_updated_at"
    t.string   "invoice_no"
  end

  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "job_application_forms", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "open"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
  end

  add_index "job_application_forms", ["slug"], name: "index_job_application_forms_on_slug", unique: true, using: :btree

  create_table "job_applications", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "email"
    t.integer  "job_application_form_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "hours_available"
    t.boolean  "domestic"
    t.string   "degree_type"
    t.string   "degree"
    t.string   "atar"
    t.string   "wam"
    t.string   "graduation"
    t.string   "status"
    t.text     "notes"
    t.string   "name"
    t.string   "other_test_score"
    t.string   "applicant_type"
    t.datetime "assessment_sent_time"
    t.integer  "assessment_sender_id"
  end

  create_table "job_descriptions", force: :cascade do |t|
    t.integer  "job_application_form_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "lessons", force: :cascade do |t|
    t.date     "date"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "item_covered"
    t.integer  "course_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "lesson_type"
  end

  create_table "live_exams", force: :cascade do |t|
    t.integer  "section_one_score",        default: 0
    t.integer  "section_two_score",        default: 0
    t.integer  "section_three_score",      default: 0
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "total_score",              default: 0
    t.float    "section_one_percentile",   default: 0.0
    t.float    "section_two_percentile",   default: 0.0
    t.float    "section_three_percentile", default: 0.0
    t.float    "total_percentile",         default: 0.0
    t.string   "section_type"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "mail_pendings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "enrolment_id"
    t.string   "category"
    t.string   "method"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "mailing_list_subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mailing_list_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailing_list_subscriptions", ["mailing_list_id"], name: "index_mailing_list_subscriptions_on_mailing_list_id", using: :btree
  add_index "mailing_list_subscriptions", ["user_id"], name: "index_mailing_list_subscriptions_on_user_id", using: :btree

  create_table "mailing_lists", force: :cascade do |t|
    t.string "name", null: false
  end

  add_index "mailing_lists", ["name"], name: "index_mailing_lists_on_name", unique: true, using: :btree

  create_table "marks", force: :cascade do |t|
    t.float    "value"
    t.boolean  "correct"
    t.integer  "user_id"
    t.integer  "essay_response_id"
    t.string   "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "marks", ["description"], name: "index_marks_on_description", using: :btree
  add_index "marks", ["essay_response_id"], name: "index_marks_on_essay_response_id", using: :btree
  add_index "marks", ["user_id"], name: "index_marks_on_user_id", using: :btree
  add_index "marks", ["value"], name: "index_marks_on_value", using: :btree

  create_table "master_features", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.text     "partials",          default: [],                 array: true
    t.string   "types",             default: [],                 array: true
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "url"
    t.string   "title"
    t.string   "icon"
    t.boolean  "show_in_sidebar"
    t.string   "model_permissions", default: [],                 array: true
    t.string   "default_state"
    t.integer  "position"
    t.integer  "product_line_id"
    t.boolean  "most_popular",      default: false
    t.integer  "popular_order"
    t.integer  "max_qty"
  end

  add_index "master_features", ["product_line_id"], name: "index_master_features_on_product_line_id", using: :btree

  create_table "mcq_answers", force: :cascade do |t|
    t.text     "answer"
    t.boolean  "correct"
    t.integer  "mcq_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mcq_answers", ["mcq_id"], name: "index_mcq_answers_on_mcq_id", using: :btree

  create_table "mcq_attempt_times", force: :cascade do |t|
    t.integer  "mcq_stem_id"
    t.integer  "sectionable_id"
    t.string   "sectionable_type"
    t.integer  "total_time",       default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "mcq_attempts", force: :cascade do |t|
    t.integer  "exercise_id"
    t.integer  "mcq_stem_id"
    t.integer  "mcq_id"
    t.integer  "mcq_answer_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  add_index "mcq_attempts", ["exercise_id"], name: "index_mcq_attempts_on_exercise_id", using: :btree
  add_index "mcq_attempts", ["mcq_answer_id"], name: "index_mcq_attempts_on_mcq_answer_id", using: :btree
  add_index "mcq_attempts", ["mcq_id"], name: "index_mcq_attempts_on_mcq_id", using: :btree
  add_index "mcq_attempts", ["mcq_stem_id"], name: "index_mcq_attempts_on_mcq_stem_id", using: :btree
  add_index "mcq_attempts", ["user_id"], name: "index_mcq_attempts_on_user_id", using: :btree

  create_table "mcq_statistics", force: :cascade do |t|
    t.integer  "total",       default: 0
    t.integer  "viewed",      default: 0
    t.integer  "correct",     default: 0
    t.float    "used",        default: 0.0
    t.float    "score",       default: 0.0
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "course_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "incorrect",   default: 0
    t.float    "correct_per", default: 0.0
  end

  create_table "mcq_stems", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "author_id"
    t.integer  "student_id"
    t.integer  "difficulty"
    t.boolean  "examinable",              default: false
    t.boolean  "published",               default: false
    t.boolean  "diagnostic"
    t.boolean  "autogenerate_difficulty", default: true,  null: false
    t.integer  "reviewer_id"
    t.boolean  "reviewed",                default: false
    t.integer  "last_editor_id"
  end

  add_index "mcq_stems", ["author_id"], name: "index_mcq_stems_on_author_id", using: :btree
  add_index "mcq_stems", ["student_id"], name: "index_mcq_stems_on_student_id", using: :btree
  add_index "mcq_stems", ["title"], name: "index_mcq_stems_on_title", unique: true, using: :btree

  create_table "mcq_student_answers", force: :cascade do |t|
    t.integer  "time_taken"
    t.integer  "mcq_answer_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "slug"
    t.datetime "time_started"
    t.datetime "time_finished"
  end

  add_index "mcq_student_answers", ["mcq_answer_id"], name: "index_mcq_student_answers_on_mcq_answer_id", using: :btree
  add_index "mcq_student_answers", ["slug"], name: "index_mcq_student_answers_on_slug", unique: true, using: :btree
  add_index "mcq_student_answers", ["user_id"], name: "index_mcq_student_answers_on_user_id", using: :btree

  create_table "mcqs", force: :cascade do |t|
    t.text     "question"
    t.float    "difficulty"
    t.boolean  "examinable"
    t.boolean  "publish"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "mcq_stem_id"
    t.integer  "exam_section_id"
    t.text     "explanation"
    t.float    "rating"
    t.boolean  "diagnostic"
    t.integer  "position"
  end

  add_index "mcqs", ["exam_section_id"], name: "index_mcqs_on_exam_section_id", using: :btree
  add_index "mcqs", ["mcq_stem_id"], name: "index_mcqs_on_mcq_stem_id", using: :btree

  create_table "mcqs_questionaires", id: false, force: :cascade do |t|
    t.integer "questionaire_id", null: false
    t.integer "mcq_id",          null: false
  end

  create_table "mock_essay_feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mock_essay_id"
    t.decimal  "rating"
    t.text     "response"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "mock_essay_feedbacks", ["mock_essay_id"], name: "index_mock_essay_feedbacks_on_mock_essay_id", using: :btree
  add_index "mock_essay_feedbacks", ["user_id"], name: "index_mock_essay_feedbacks_on_user_id", using: :btree

  create_table "mock_essays", force: :cascade do |t|
    t.string   "essay_file_name"
    t.string   "essay_content_type"
    t.integer  "essay_file_size"
    t.datetime "essay_updated_at"
    t.integer  "mock_exam_essay_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "mock_exam_essays", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "live_exam_id"
    t.integer  "status",          default: 0
    t.datetime "marked_at"
    t.integer  "assigned_tutors", default: [],              array: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "new_courses", force: :cascade do |t|
    t.string   "name"
    t.integer  "class_size"
    t.integer  "students_count"
    t.datetime "enrolment_end"
    t.date     "expiry_date"
    t.integer  "product_version_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "online_exam_attempts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "online_exam_id"
    t.float    "percentile"
    t.integer  "mark"
    t.datetime "completed_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "online_exam_attempts", ["online_exam_id"], name: "index_online_exam_attempts_on_online_exam_id", using: :btree
  add_index "online_exam_attempts", ["user_id"], name: "index_online_exam_attempts_on_user_id", using: :btree

  create_table "online_exam_prints", force: :cascade do |t|
    t.integer  "online_exam_id"
    t.integer  "user_id"
    t.integer  "print_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "online_exams", force: :cascade do |t|
    t.string   "title"
    t.text     "instruction"
    t.boolean  "published",             default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "is_finish",             default: false
    t.boolean  "show_stat",             default: false
    t.boolean  "locked",                default: false
    t.integer  "position"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "reference_number"
    t.decimal  "redundant_total_cost", precision: 8, scale: 2
    t.decimal  "redundant_method_fee", precision: 8, scale: 2
    t.string   "brain_tree_reference"
    t.datetime "paid_at"
    t.integer  "user_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "authoriser_id"
    t.integer  "status",                                       default: 0
    t.integer  "purchase_method"
    t.integer  "subscription_id"
    t.integer  "subscription_status",                          default: 3, null: false
    t.integer  "course_id"
    t.integer  "creator_id"
  end

  add_index "orders", ["creator_id"], name: "index_orders_on_creator_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "orders_promos", id: false, force: :cascade do |t|
    t.integer "promo_id", null: false
    t.integer "order_id", null: false
  end

  add_index "orders_promos", ["order_id", "promo_id"], name: "index_orders_promos_on_order_id_and_promo_id", using: :btree
  add_index "orders_promos", ["promo_id", "order_id"], name: "index_orders_promos_on_promo_id_and_order_id", using: :btree

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "overall_avg",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overseeings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "overseeings", ["tag_id"], name: "index_overseeings_on_tag_id", using: :btree
  add_index "overseeings", ["user_id"], name: "index_overseeings_on_user_id", using: :btree

  create_table "performance_stats", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "tag_id",                       null: false
    t.integer  "performable_id",               null: false
    t.string   "performable_type",             null: false
    t.integer  "unit_completed",   default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "performance_stats", ["performable_type", "performable_id"], name: "index_performance_stats_on_performable_type_and_performable_id", using: :btree
  add_index "performance_stats", ["tag_id"], name: "index_performance_stats_on_tag_id", using: :btree
  add_index "performance_stats", ["user_id"], name: "index_performance_stats_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "blog_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug"
    t.string   "author",             default: "Unknown"
    t.string   "alt_text"
  end

  create_table "product_lines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_packages", force: :cascade do |t|
    t.string   "name"
    t.datetime "valid_date"
    t.decimal  "cost",       precision: 7, scale: 2, default: 0.0
    t.float    "weight",                             default: 0.0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "slug"
  end

  add_index "product_packages", ["cost"], name: "index_product_packages_on_cost", using: :btree
  add_index "product_packages", ["name"], name: "index_product_packages_on_name", using: :btree
  add_index "product_packages", ["valid_date"], name: "index_product_packages_on_valid_date", using: :btree
  add_index "product_packages", ["weight"], name: "index_product_packages_on_weight", using: :btree

  create_table "product_types", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.boolean  "is_additional_feature"
  end

  create_table "product_version_feature_prices", force: :cascade do |t|
    t.integer  "product_version_id"
    t.integer  "master_feature_id"
    t.float    "price"
    t.integer  "qty"
    t.boolean  "is_default"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "is_additional",      default: false
    t.integer  "access_limit"
  end

  add_index "product_version_feature_prices", ["master_feature_id"], name: "index_product_version_feature_prices_on_master_feature_id", using: :btree
  add_index "product_version_feature_prices", ["product_version_id"], name: "index_product_version_feature_prices_on_product_version_id", using: :btree

  create_table "product_versions", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",           precision: 8, scale: 2
    t.string   "type"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "slug"
    t.text     "description",                             default: "",    null: false
    t.integer  "product_line_id"
    t.string   "couple_name"
    t.integer  "course_type"
    t.boolean  "freemium",                                default: false
    t.boolean  "early_bird",                              default: false
  end

  add_index "product_versions", ["product_line_id"], name: "index_product_versions_on_product_line_id", using: :btree
  add_index "product_versions", ["slug"], name: "index_product_versions_on_slug", unique: true, using: :btree

  create_table "promo_visits", force: :cascade do |t|
    t.integer  "promo_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "promo_visits", ["promo_id"], name: "index_promo_visits_on_promo_id", using: :btree

  create_table "promos", force: :cascade do |t|
    t.string   "token"
    t.boolean  "stackable",          default: false, null: false
    t.integer  "strategy",           default: 0,     null: false
    t.decimal  "amount",             default: 0.0,   null: false
    t.integer  "user_id"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "generated_from_id"
    t.integer  "used_times",         default: 1
    t.date     "expiry_date"
    t.integer  "product_version_id"
  end

  add_index "promos", ["generated_from_id"], name: "index_promos_on_generated_from_id", using: :btree
  add_index "promos", ["token"], name: "index_promos_on_token", unique: true, using: :btree
  add_index "promos", ["user_id"], name: "index_promos_on_user_id", using: :btree

  create_table "public_updates", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "contact_number"
  end

  create_table "purchase_addons", force: :cascade do |t|
    t.datetime "paid_at"
    t.datetime "date_activated"
    t.datetime "date_deactivated"
    t.text     "features"
    t.float    "subtotal"
    t.float    "gst"
    t.float    "paypal_fee"
    t.string   "paypal_payment"
    t.string   "paypal_token"
    t.string   "banktrans"
    t.boolean  "paypal"
    t.boolean  "bank"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "enrolment_id"
  end

  add_index "purchase_addons", ["enrolment_id"], name: "index_purchase_addons_on_enrolment_id", using: :btree

  create_table "purchase_items", force: :cascade do |t|
    t.decimal  "initial_cost",         precision: 8, scale: 2
    t.decimal  "added_gst",            precision: 8, scale: 2
    t.decimal  "method_fee",           precision: 8, scale: 2
    t.string   "purchase_description"
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.decimal  "discount_applied",                             default: 0.0, null: false
    t.decimal  "shipping_cost",                                default: 0.0, null: false
  end

  add_index "purchase_items", ["order_id"], name: "index_purchase_items_on_order_id", using: :btree
  add_index "purchase_items", ["purchasable_type", "purchasable_id"], name: "index_purchase_items_on_purchasable_type_and_purchasable_id", using: :btree
  add_index "purchase_items", ["user_id"], name: "index_purchase_items_on_user_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.string   "email"
    t.string   "card_token"
    t.text     "notification_params"
    t.string   "status"
    t.string   "transaction_id"
    t.datetime "purchased_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string   "year"
    t.boolean  "umat_high_school"
    t.boolean  "umat_uni"
    t.text     "source",                default: [],              array: true
    t.text     "last_source"
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "university_id"
    t.integer  "degree_id"
    t.integer  "student_level",         default: 0
    t.integer  "highschool_year_level"
    t.string   "current_highschool"
    t.string   "target_uni_course"
    t.string   "language_spoken"
  end

  add_index "questionnaires", ["degree_id"], name: "index_questionnaires_on_degree_id", using: :btree
  add_index "questionnaires", ["university_id"], name: "index_questionnaires_on_university_id", using: :btree
  add_index "questionnaires", ["user_id"], name: "index_questionnaires_on_user_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type", using: :btree
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id", using: :btree

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type", using: :btree

  create_table "resumes", force: :cascade do |t|
    t.integer  "job_application_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "section_attempts", force: :cascade do |t|
    t.float    "percentile"
    t.integer  "mark"
    t.datetime "completed_at"
    t.integer  "attemptable_id"
    t.string   "attemptable_type"
    t.integer  "section_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "assessment_attempt_id"
  end

  add_index "section_attempts", ["assessment_attempt_id"], name: "index_section_attempts_on_assessment_attempt_id", using: :btree
  add_index "section_attempts", ["attemptable_type", "attemptable_id"], name: "index_section_attempts_on_attemptable_type_and_attemptable_id", using: :btree
  add_index "section_attempts", ["section_id"], name: "index_section_attempts_on_section_id", using: :btree

  create_table "section_item_attempts", force: :cascade do |t|
    t.integer  "section_attempt_id"
    t.integer  "section_item_id"
    t.integer  "mcq_stem_id"
    t.integer  "mcq_answer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "section_item_attempts", ["mcq_answer_id"], name: "index_section_item_attempts_on_mcq_answer_id", using: :btree
  add_index "section_item_attempts", ["mcq_stem_id"], name: "index_section_item_attempts_on_mcq_stem_id", using: :btree
  add_index "section_item_attempts", ["section_attempt_id"], name: "index_section_item_attempts_on_section_attempt_id", using: :btree
  add_index "section_item_attempts", ["section_item_id"], name: "index_section_item_attempts_on_section_item_id", using: :btree

  create_table "section_items", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "mcq_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "section_items", ["mcq_id"], name: "index_section_items_on_mcq_id", using: :btree
  add_index "section_items", ["section_id"], name: "index_section_items_on_section_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "title"
    t.integer  "duration"
    t.integer  "position"
    t.integer  "sectionable_id"
    t.string   "sectionable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "sections", ["sectionable_type", "sectionable_id"], name: "index_sections_on_sectionable_type_and_sectionable_id", using: :btree

  create_table "shippings", force: :cascade do |t|
    t.string   "country"
    t.decimal  "shipping_amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "staff_profiles", force: :cascade do |t|
    t.integer  "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "staff_profiles", ["staff_id"], name: "index_staff_profiles_on_staff_id", using: :btree

  create_table "stem_students", force: :cascade do |t|
    t.integer  "time_left"
    t.text     "description"
    t.string   "title"
    t.string   "mcqs"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.integer  "mcq_stem_id"
    t.integer  "subject_id"
  end

  add_index "stem_students", ["mcq_stem_id"], name: "index_stem_students_on_mcq_stem_id", using: :btree
  add_index "stem_students", ["subject_id"], name: "index_stem_students_on_subject_id", using: :btree
  add_index "stem_students", ["user_id"], name: "index_stem_students_on_user_id", using: :btree

  create_table "student_class_sessions", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "frequency"
    t.integer  "student_class_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "student_class_sessions", ["student_class_id"], name: "index_student_class_sessions_on_student_class_id", using: :btree

  create_table "student_classes", force: :cascade do |t|
    t.string   "name"
    t.integer  "size"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "course_version_id"
    t.integer  "active_subject_id"
    t.text     "item_coverd"
  end

  add_index "student_classes", ["active_subject_id"], name: "index_student_classes_on_active_subject_id", using: :btree
  add_index "student_classes", ["course_version_id"], name: "index_student_classes_on_course_version_id", using: :btree

  create_table "student_questions", force: :cascade do |t|
    t.text     "question"
    t.datetime "date_published"
    t.boolean  "published"
    t.integer  "user_id"
    t.integer  "tutor_answer_id"
    t.integer  "subject_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slug"
  end

  add_index "student_questions", ["date_published"], name: "index_student_questions_on_date_published", using: :btree
  add_index "student_questions", ["slug"], name: "index_student_questions_on_slug", unique: true, using: :btree
  add_index "student_questions", ["subject_id"], name: "index_student_questions_on_subject_id", using: :btree
  add_index "student_questions", ["tutor_answer_id"], name: "index_student_questions_on_tutor_answer_id", using: :btree
  add_index "student_questions", ["user_id"], name: "index_student_questions_on_user_id", using: :btree

  create_table "students_classes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "student_class_id"
  end

  add_index "students_classes", ["student_class_id"], name: "index_students_classes_on_student_class_id", using: :btree
  add_index "students_classes", ["user_id"], name: "index_students_classes_on_user_id", using: :btree

  create_table "students_course_versions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_version_id"
  end

  create_table "study_buddies", force: :cascade do |t|
    t.string   "name",                         null: false
    t.string   "email",           default: "", null: false
    t.string   "phone_number"
    t.boolean  "grad_student",                 null: false
    t.integer  "exam_to_prepare",              null: false
    t.integer  "university_id",                null: false
    t.integer  "degree_id",                    null: false
    t.integer  "city",                         null: false
    t.integer  "city_area",                    null: false
    t.string   "suburb"
    t.integer  "focus_area",                   null: false
    t.string   "focus_study"
    t.integer  "buddy_type"
    t.string   "other_info"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "subject_mcq_stems", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "mcq_stem_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "subject_mcq_stems", ["mcq_stem_id"], name: "index_subject_mcq_stems_on_mcq_stem_id", using: :btree
  add_index "subject_mcq_stems", ["subject_id"], name: "index_subject_mcq_stems_on_subject_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.integer  "course_id"
  end

  add_index "subjects", ["course_id"], name: "index_subjects_on_course_id", using: :btree
  add_index "subjects", ["slug"], name: "index_subjects_on_slug", unique: true, using: :btree
  add_index "subjects", ["title"], name: "index_subjects_on_title", using: :btree

  create_table "survey_answers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "survey_question_id"
    t.text     "answer"
    t.integer  "rating"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "survey_answers", ["survey_question_id"], name: "index_survey_answers_on_survey_question_id", using: :btree
  add_index "survey_answers", ["user_id"], name: "index_survey_answers_on_user_id", using: :btree

  create_table "survey_questions", force: :cascade do |t|
    t.integer  "survey_id"
    t.text     "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "survey_questions", ["survey_id"], name: "index_survey_questions_on_survey_id", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.string   "title"
    t.datetime "date_published"
    t.datetime "date_start"
    t.boolean  "published"
    t.datetime "date_closed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
  end

  add_index "surveys", ["slug"], name: "index_surveys_on_slug", unique: true, using: :btree

  create_table "system_infos", force: :cascade do |t|
    t.string   "ip"
    t.string   "user_agent"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "product_line"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "exclude_taggable_id"
    t.string   "exclude_taggable_type"
  end

  add_index "taggings", ["exclude_taggable_type", "exclude_taggable_id"], name: "index_taggings_on_exclude_taggable_type_and_exclude_taggable_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "tagging_count"
    t.integer  "parent_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "is_public"
  end

  add_index "tags", ["parent_id"], name: "index_tags_on_parent_id", using: :btree

  create_table "tags_tutor_profiles", id: false, force: :cascade do |t|
    t.integer "tag_id",           null: false
    t.integer "tutor_profile_id", null: false
  end

  create_table "textbook_prints", force: :cascade do |t|
    t.integer  "textbook_id"
    t.integer  "user_id"
    t.integer  "print_count"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "textbook_urls", force: :cascade do |t|
    t.integer  "textbook_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "textbooks", force: :cascade do |t|
    t.string   "title"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "for_textbook",              default: false
    t.boolean  "for_textbook_slide",        default: false
    t.boolean  "for_live_handout",          default: false
    t.boolean  "for_live_slide",            default: false
    t.boolean  "for_document",              default: false
    t.boolean  "for_timetable",             default: false
    t.integer  "product_line_id"
    t.integer  "user_id"
    t.boolean  "for_downloadable_resource", default: false
    t.boolean  "for_paid"
    t.boolean  "for_trial"
    t.integer  "course_id"
    t.boolean  "for_weekend",               default: false
  end

  add_index "textbooks", ["course_id"], name: "index_textbooks_on_course_id", using: :btree

  create_table "ticket_answers", force: :cascade do |t|
    t.text     "content"
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.boolean  "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ticket_answers", ["ticket_id"], name: "index_ticket_answers_on_ticket_id", using: :btree
  add_index "ticket_answers", ["user_id"], name: "index_ticket_answers_on_user_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.string   "title"
    t.text     "question"
    t.integer  "asker_id"
    t.integer  "answerer_id",                       null: false
    t.boolean  "public",            default: false, null: false
    t.datetime "answered_at"
    t.integer  "questionable_id"
    t.string   "questionable_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "email"
    t.string   "phone_number"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "remind",            default: false, null: false
    t.integer  "resolver_id"
    t.integer  "status"
    t.string   "comment"
    t.string   "feedback",          default: "No"
    t.string   "given_type"
    t.integer  "given_id"
    t.boolean  "escalated",         default: false
    t.datetime "opened_at"
    t.boolean  "complaint",         default: false
    t.datetime "follow_up_date"
  end

  add_index "tickets", ["answerer_id"], name: "index_tickets_on_answerer_id", using: :btree
  add_index "tickets", ["asker_id"], name: "index_tickets_on_asker_id", using: :btree
  add_index "tickets", ["questionable_type", "questionable_id"], name: "index_tickets_on_questionable_type_and_questionable_id", using: :btree

  create_table "transfer_transactions", force: :cascade do |t|
    t.datetime "payment_confirmed"
    t.float    "amount"
    t.boolean  "paid"
    t.string   "banking_reference"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "course_id"
    t.integer  "user_id"
  end

  add_index "transfer_transactions", ["course_id"], name: "index_transfer_transactions_on_course_id", using: :btree
  add_index "transfer_transactions", ["user_id"], name: "index_transfer_transactions_on_user_id", using: :btree

  create_table "tutor_answers", force: :cascade do |t|
    t.text     "answer"
    t.datetime "date_published"
    t.boolean  "published"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tutor_answers", ["date_published"], name: "index_tutor_answers_on_date_published", using: :btree
  add_index "tutor_answers", ["user_id"], name: "index_tutor_answers_on_user_id", using: :btree

  create_table "tutor_availabilities", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "repeatability"
    t.text     "location"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "tutor_profile_id"
    t.integer  "status",            default: 0, null: false
    t.integer  "tutor_schedule_id"
  end

  add_index "tutor_availabilities", ["tutor_profile_id"], name: "index_tutor_availabilities_on_tutor_profile_id", using: :btree
  add_index "tutor_availabilities", ["tutor_schedule_id"], name: "index_tutor_availabilities_on_tutor_schedule_id", using: :btree

  create_table "tutor_profiles", force: :cascade do |t|
    t.integer  "tutor_id"
    t.boolean  "private_tutor"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "issue_ticket",  default: true
  end

  add_index "tutor_profiles", ["tutor_id"], name: "index_tutor_profiles_on_tutor_id", using: :btree

  create_table "tutor_schedules", force: :cascade do |t|
    t.integer  "repeatability"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "location"
    t.integer  "tutor_profile_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "allow_booking_until", default: 7
  end

  create_table "tutors_classes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "student_class_id"
  end

  add_index "tutors_classes", ["student_class_id"], name: "index_tutors_classes_on_student_class_id", using: :btree
  add_index "tutors_classes", ["user_id"], name: "index_tutors_classes_on_user_id", using: :btree

  create_table "universities", force: :cascade do |t|
    t.string   "name"
    t.string   "alternate_name"
    t.string   "location"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_announcements", force: :cascade do |t|
    t.integer  "announcement_id"
    t.boolean  "viewed"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "view_count",      default: 0
  end

  create_table "user_stats", force: :cascade do |t|
    t.float    "stuent_stat",   default: 0.0
    t.float    "average_stat",  default: 0.0
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "course_id"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "user_stats", ["viewable_type", "viewable_id"], name: "index_user_stats_on_viewable_type_and_viewable_id", using: :btree

  create_table "user_subjects", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "active_subject_id"
  end

  add_index "user_subjects", ["active_subject_id"], name: "index_user_subjects_on_active_subject_id", using: :btree
  add_index "user_subjects", ["user_id"], name: "index_user_subjects_on_user_id", using: :btree

  create_table "user_surveys", force: :cascade do |t|
    t.integer "user_id"
    t.integer "survey_id"
    t.boolean "is_submited"
  end

  add_index "user_surveys", ["survey_id"], name: "index_user_surveys_on_survey_id", using: :btree
  add_index "user_surveys", ["user_id"], name: "index_user_surveys_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                    default: "",      null: false
    t.string   "encrypted_password",                       default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.date     "date_of_birth"
    t.datetime "date_signed_up"
    t.text     "bio"
    t.string   "profile_image"
    t.string   "slug"
    t.integer  "role",                                     default: 0
    t.integer  "area",                                     default: 0
    t.integer  "appointment_length",                       default: 60
    t.string   "phone_number"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                        default: 0
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "seen_discount_popup",                      default: false,   null: false
    t.string   "uid",                                      default: ""
    t.string   "provider",                                 default: "email"
    t.integer  "status",                                   default: 0
    t.date     "first_enrolment_date"
    t.string   "unique_session_id",             limit: 20
    t.string   "session_url"
    t.boolean  "email_subscription",                       default: true
    t.string   "payment_flow_step"
    t.integer  "feature_access_count",                     default: 0
    t.integer  "total_online_time",                        default: 0
    t.boolean  "data_transferred",                         default: false
    t.boolean  "essay_transferred",                        default: false
    t.boolean  "private_tutor_subscribe_email",            default: false
    t.integer  "active_course_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["date_of_birth"], name: "index_users_on_date_of_birth", using: :btree
  add_index "users", ["date_signed_up"], name: "index_users_on_date_signed_up", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "video_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "video_categories", ["subject_id"], name: "index_video_categories_on_subject_id", using: :btree

  create_table "vods", force: :cascade do |t|
    t.string   "title"
    t.datetime "date_published"
    t.boolean  "published"
    t.integer  "viewcount"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "subject_id"
    t.integer  "video_category_id"
    t.string   "description",        default: "None"
  end

  add_index "vods", ["subject_id"], name: "index_vods_on_subject_id", using: :btree
  add_index "vods", ["video_category_id"], name: "index_vods_on_video_category_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree

  create_table "watcheds", force: :cascade do |t|
    t.integer  "vod_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "watcheds", ["user_id"], name: "index_watcheds_on_user_id", using: :btree
  add_index "watcheds", ["vod_id"], name: "index_watcheds_on_vod_id", using: :btree

  add_foreign_key "access_documents", "documents"
  add_foreign_key "access_documents", "users"
  add_foreign_key "active_subjects", "course_versions"
  add_foreign_key "active_subjects", "subjects"
  add_foreign_key "appointments", "tutor_availabilities"
  add_foreign_key "assessment_attempts", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "contact_forms", "contact_locations"
  add_foreign_key "contacts", "contact_locations"
  add_foreign_key "course_staffs", "courses"
  add_foreign_key "course_staffs", "staff_profiles"
  add_foreign_key "course_versions", "course_addresses"
  add_foreign_key "documents", "users"
  add_foreign_key "enrolments", "courses"
  add_foreign_key "essay_responses", "essays"
  add_foreign_key "essay_responses", "users"
  add_foreign_key "essay_tutor_feedbacks", "essay_responses"
  add_foreign_key "essay_tutor_feedbacks", "users"
  add_foreign_key "essay_tutor_responses", "essay_responses", on_delete: :cascade
  add_foreign_key "essays", "exams"
  add_foreign_key "exam_sections", "exams"
  add_foreign_key "exams", "subjects"
  add_foreign_key "excluded_tags_staff_profiles", "staff_profiles"
  add_foreign_key "excluded_tags_staff_profiles", "tags"
  add_foreign_key "excluded_tags_tutor_profiles", "tags"
  add_foreign_key "excluded_tags_tutor_profiles", "tutor_profiles"
  add_foreign_key "exercises", "users"
  add_foreign_key "faq_pages", "faq_topics"
  add_foreign_key "faqs", "courses"
  add_foreign_key "faqs", "faq_categories"
  add_foreign_key "features_instructions", "product_types"
  add_foreign_key "invoices", "users"
  add_foreign_key "mailing_list_subscriptions", "mailing_lists"
  add_foreign_key "mailing_list_subscriptions", "users"
  add_foreign_key "marks", "essay_responses"
  add_foreign_key "marks", "users"
  add_foreign_key "master_features", "product_lines"
  add_foreign_key "mcq_answers", "mcqs"
  add_foreign_key "mcq_attempts", "exercises"
  add_foreign_key "mcq_attempts", "mcq_answers"
  add_foreign_key "mcq_attempts", "mcq_stems"
  add_foreign_key "mcq_attempts", "mcqs"
  add_foreign_key "mcq_attempts", "users"
  add_foreign_key "mcq_student_answers", "mcq_answers"
  add_foreign_key "mcq_student_answers", "users"
  add_foreign_key "mcqs", "exam_sections"
  add_foreign_key "mcqs", "mcq_stems"
  add_foreign_key "mock_essay_feedbacks", "mock_essays"
  add_foreign_key "mock_essay_feedbacks", "users"
  add_foreign_key "online_exam_attempts", "online_exams"
  add_foreign_key "online_exam_attempts", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "overseeings", "tags"
  add_foreign_key "overseeings", "users"
  add_foreign_key "product_versions", "product_lines"
  add_foreign_key "promo_visits", "promos"
  add_foreign_key "promos", "orders", column: "generated_from_id"
  add_foreign_key "promos", "users"
  add_foreign_key "purchase_addons", "enrolments"
  add_foreign_key "purchase_items", "orders"
  add_foreign_key "purchase_items", "users"
  add_foreign_key "questionnaires", "degrees"
  add_foreign_key "questionnaires", "universities"
  add_foreign_key "questionnaires", "users"
  add_foreign_key "section_attempts", "assessment_attempts"
  add_foreign_key "section_attempts", "sections"
  add_foreign_key "section_item_attempts", "mcq_answers"
  add_foreign_key "section_item_attempts", "mcq_stems"
  add_foreign_key "section_item_attempts", "section_attempts"
  add_foreign_key "section_item_attempts", "section_items"
  add_foreign_key "section_items", "mcqs"
  add_foreign_key "section_items", "sections"
  add_foreign_key "stem_students", "mcq_stems"
  add_foreign_key "stem_students", "subjects"
  add_foreign_key "stem_students", "users"
  add_foreign_key "student_class_sessions", "student_classes"
  add_foreign_key "student_classes", "active_subjects"
  add_foreign_key "student_classes", "course_versions"
  add_foreign_key "student_questions", "subjects"
  add_foreign_key "student_questions", "tutor_answers"
  add_foreign_key "student_questions", "users"
  add_foreign_key "students_classes", "student_classes"
  add_foreign_key "students_classes", "users"
  add_foreign_key "subject_mcq_stems", "mcq_stems"
  add_foreign_key "subject_mcq_stems", "subjects"
  add_foreign_key "subjects", "courses"
  add_foreign_key "survey_answers", "survey_questions"
  add_foreign_key "survey_answers", "users"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "taggings", "tags"
  add_foreign_key "textbooks", "courses"
  add_foreign_key "ticket_answers", "tickets"
  add_foreign_key "ticket_answers", "users"
  add_foreign_key "tickets", "users", column: "answerer_id"
  add_foreign_key "tickets", "users", column: "asker_id"
  add_foreign_key "transfer_transactions", "courses"
  add_foreign_key "transfer_transactions", "users"
  add_foreign_key "tutor_answers", "users"
  add_foreign_key "tutor_availabilities", "tutor_profiles"
  add_foreign_key "tutor_availabilities", "tutor_schedules"
  add_foreign_key "tutors_classes", "student_classes"
  add_foreign_key "tutors_classes", "users"
  add_foreign_key "user_subjects", "active_subjects"
  add_foreign_key "user_subjects", "users"
  add_foreign_key "user_surveys", "surveys"
  add_foreign_key "user_surveys", "users"
  add_foreign_key "video_categories", "subjects"
  add_foreign_key "vods", "subjects"
  add_foreign_key "vods", "video_categories"
  add_foreign_key "votes", "users"
end
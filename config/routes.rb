Rails.application.routes.draw do
  namespace :ucat do
    namespace :dashboard do
      get 'home'
    end
  end 
  resources :waitlist_users
  resources :ucat_exercises do
    collection do
      get 'welcome'
      get 'instructions'
      get 'question1'
      get 'question2'
      get 'question3'
      get 'question4'
      get 'question5'
      get 'question6'
      get 'question7'
      get 'question8'
      get 'question9'
      get 'question10'
      get 'review'
    end
  end
  resources :email_customises do
    collection do
      get 'courses'
      get 'duplicate'
    end
  end
  get '/student_enrolement_process' => 'courses#student_enrolement_process'
  get 'posts/post_unsubscribe' => 'posts#post_unsubscribe'
  post '/rate' => 'rater#create', :as => 'rate'
  put '/rate' => 'rater#update'
  resources :comments
  resources :interaction_logs
  resources :tickets do
    member do
      post 'toggle_reminder'
      post 'make_public'
      post 'make_private'
      get 'escalate_issue'
      post 'mark_complaint'
      post 'mark_for_resolved'
    end
    collection do
      get 'tags'
      delete 'destroy_old_issues'
    end
    resources :ticket_answers do
      member do
        get 'find_helpful', as: :find_helpful
        # post 'select_answer'
      end
    end
  end

  resources :user_emails, only: :index do
    collection do
      get :index_filter
    end
    post :mass_send, on: :collection
    get :download, on: :collection
    get :reset_textbook_access, on: :member
    get :update_book_access, on: :member
    delete :destroy_incomplete_transactions, on: :collection
    get :verify_transactions, on: :collection
  end
  get 'textbook_deliveries', to: 'user_emails#textbook_deliveries'
  get 'errors/not_found'
  get 'errors/internal_server_error'

  resources :tutor_schedules
  resources :purchase_addons do
    collection do
      post 'paypal_payment' => 'purchase_addons#paypal_payment'
    end
  end

  resources :diagnostic_test_attempts, except: [:edit, :update] do
    resources :section_attempts, only: [:index, :show] do
      resources :section_item_attempts, only: :index do
        collection do
          put 'complete'
          get 'review'
          put 'update_answer'
        end
        member do
          get :exam_review_videos
          get :exam_review_textbooks
          get :exam_feedback
        end
      end
    end
  end


  resources :shippings do
    collection do
      post 'update_out_of_stock'
    end
  end

  resources :textbook_deliveries do
    collection do
      post 'create_or_update_textbook'
    end
  end

  resources :course_recommender_usages do
    collection do
      get 'tracking'
    end
  end

  resources :online_mock_exam_attempts, except: [:edit, :update] do
    member do
      get :download
    end
    collection do
      get :refresh_document
    end
    resources :section_attempts, only: [:index, :show] do
      resources :section_item_attempts, only: :index do
        collection do
          put 'complete'
          get 'review'
          put 'update_answer'
        end
        member do
          get :exam_review_videos
          get :exam_review_textbooks
          get :exam_feedback
          get :mcq_exam_question_rating
          post :create_update_question_rating
        end
      end
    end
  end

  resources :online_mock_exam_attempt_temps, except: [:edit, :update] do
    member do
      get :download
    end
    collection do
      get :refresh_document
    end
    resources :section_attempts, only: [:index, :show] do
      resources :section_item_attempts, only: :index do
        collection do
          put 'complete'
          get 'review'
          put 'update_answer'
        end
        member do
          get :exam_review_videos
          get :exam_review_textbooks
          get :exam_feedback
          get :mcq_exam_question_rating
          post :create_update_question_rating
        end
      end
    end
  end

  resources :online_exam_attempts, except: [:edit, :update] do
    collection do
      post 'create_print_exam'
    end
    member do
      get 'print_exam_questions'
      get :print_count
    end
    resources :section_attempts, only: [:index, :show] do
      resources :section_item_attempts, only: :index do
        collection do
          put 'complete'
          get 'review'
          put 'update_answer'
        end
        member do
          get :exam_review_videos
          get :exam_review_textbooks
          get :exam_feedback
          get :mcq_exam_question_rating
          post :create_update_question_rating
        end
      end
    end
  end

  resources :online_mock_exams do
    collection do
      get :archived_online_mock_exams
    end
  end
  resources :online_exams do
    member do
      get :download
      get :change_show_stat
      put :change_lock
      post :duplicate
    end
    resources :sections do
      resources :section_items do
        member do
          delete :remove_question
        end
      end
    end
    collection do
      get :check_position
      get :archived_online_exams
      post :update_product_line_positions
    end
  end

  resources :diagnostic_tests do
    member do
      get :change_show_stat
      put :change_lock
    end
    resources :sections do
      resources :section_items do
        member do
          delete :remove_question
        end
      end
    end
  end

  get 'discount/index'
  get "/exercises/:exercise_id/mcq_attempts/review" => "exercise_review#review", as: :review_exercise_exercise_review
  delete 'exercises/:exercise_id/return_to_mcq' => 'exercise_mcqs#return_to_mcq', as: :return_to_mcq
  post 'exercises/:id/repeat' => 'exercise_mcqs#repeat', as: :repeat
  post 'exercises/review_questions' => 'exercise_mcqs#review_questions', as: :review_questions
  resources :exercises do
    resources :exercise_review, except: [:new, :edit, :create, :edit, :update, :destroy] do
      member do
        get :exercise_review_videos
        get :exercise_review_textbooks
        get :give_feedback
        get :mcq_exam_question_rating
        post :create_update_question_rating
      end
    end
    resources :mcq_attempts, except: [:new, :edit, :create,
            :edit, :update, :destroy] do
      collection do
        put 'update_answer'
        put 'update_mcq_answer'
      end
    end
  end

  resources :job_application_forms, :path => 'jobs' do
    resources :job_applications, :path => 'job-applications' do
      get 'download_all', on: :collection
      get 'get_tag_childrens', on: :collection
      get 'download', on: :member
    end

    get 'archived_jobs', on: :collection
    get 'available-positions', to: 'job_application_forms#available_positions', on: :collection

    get 'show_available_position', on: :member
  end
  resources :job_applications, :path => 'job-applications', only: [] do
    get 'search_applications', on: :collection
    post 'update_interview_date', on: :collection
  end

  # resources :features
  resources :master_features do
    post :master_feature_tags, on: :collection
  end
  # get 'enrolment/:id/' => 'enrolments#show'
  resources :enrolments, only: [:show] do
    member do
      get :student_addon_enrolment
      get :transfer_by
      patch :unenrol_or_renrol
    end
    collection do
      put :attach_enrolment_details
    end
  end

  resources :common_contents, except: [:show, :index]
  resources :free_study_buddies
  resources :study_buddies
  resources :countdown_timers
  resources :download_hit_counters, only: [:index, :edit, :update]
  get 'courses/public_course_cities' => 'courses_filter#public_course_cities'
  get 'courses/filtered_product_versions' => 'courses_filter#filtered_product_versions'
  get 'courses/filtered_transfer_courses' => 'courses_filter#filtered_transfer_courses'

  get 'courses/list_cities' => 'courses_filter#list_cities'
  get 'courses/list_course_lessons' => 'courses_filter#list_course_lessons'
  get 'courses/list_courses_by_city' => 'courses_filter#list_courses_by_city'
  resources :courses do
    get 'enrolments/enrol' => 'enrolments#enrol'
    get 'enrolments/discount_course_enrolment'=> 'enrolments#discount_course_enrolment'
    get 'enrolments/quick_enrol' => 'enrolments#quick_enrol'
    get 'enrolments/student_course_enrolment' => 'enrolments#student_course_enrolment'
    post 'enrolments/paypal_payment' => 'enrolments#paypal_payment'
    post 'enrolments/transfer_payment' => 'enrolments#transfer_payment'
    get 'enrolments/cancel' => 'enrolments#cancel'
    get 'enrolments/transfer_course' => 'enrolments#transfer_course'
    get 'enrolments/custom_enrol' => 'enrolments#custom_enrol'
    
    get :trial_enabled, on: :member
    collection do
      post :set_current_course
      get :archived_courses
      get :get_course_type
    end
    member do
      post :duplicate
      post :unarchived
      get :update_course_id
      get :get_addons
    end
  end
  
  resources :transfer_transactions do
    collection do
      get '/transfer_transaction' => 'transfer_transaction#show'
    end
  end

  get '/users/view_as/:user_id' => 'users#become', as: :view_as
  resources :users, except: [:show, :index] do
    collection do
      get :check_email
      get :check_username
      get :reset_ol_exam
      get :reset_diganostic
      get :reset_essay
      get :reset_mock_exam
      delete :destroy_all
      delete :destroy_ongoing_orders
      get :verify_users
      get :cancel_appointment
      post :study_guide
      post :free_gamsat_trial
      get :reset_online_mock_exam_attempt
      get :display_expiry_date
    end
    resources :enrolments, except: [:index, :show] do
    end
    member do
      get :transfer_data
      put :deactivate
      put :resend_invitation
      get :reset_exams
      get :update_contact
      put :save_detail
      get :course_details
      post :transfer
      get :tutor_interaction_logs
    end
    post :generate_new_password_email
    # get 'enrolments'=> 'user_enrolments#index'
  end

  devise_for :users, skip: [:registrations], path: '/', path_names: {
      sign_in: 'login', sign_out: 'sign_out', password: 'login/forgotpassword'}, controllers: { invitations: 'users/invitations', sessions: 'users/sessions', confirmations: 'users/confirmations', passwords: 'users/passwords'}

  devise_scope :user do
    # devise path inherit
    get '/cancel' => 'users/registrations#cancel', as: :cancel_user_registration
    post '/register' => 'users/registrations#create', as: :user_registration
    put '/edit' => 'users/registrations#update', as: :user_update
    get '/register' => 'users/registrations#new', as: :new_user_registration
    get '/edit' => 'users/registrations#edit', as: :edit_user_registration
    patch '/' => 'users/registrations#update'
    put '/' => 'users/registrations#update'
    delete '/' => 'users/registrations#destroy'

    get "/login/forgotpassword" => "users/passwords#new"
    get '/auth/is_signed_in' => 'users/sessions#is_signed_in', as: :is_signed_in
    get '/auth' => 'users/sessions#new'
    get '/auth/password' => 'devise/passwords#new'
  end

  get '/sign_in', to: redirect("/login")
  get '/gamsat-preparation-courses/about', to: redirect("/gamsat-preparation-courses/overview")
  get '/about', to: redirect("/gamsat-preparation-courses/overview")

  get '/gamsat-preparation-courses/online-basic', to: redirect{ |params, request| "/gamsat-preparation-courses/online-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/online', to: redirect{ |params, request| "/gamsat-preparation-courses/online-comprehensive?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/attendence-basic', to:redirect{ |params, request| "/gamsat-preparation-courses/attendance-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/attendence-d4588d4f-d803-4a68-8b06-06c2af9406ee', to: redirect{ |params, request| "/gamsat-preparation-courses/attendance-comprehensive?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/attendence-all', to: redirect{ |params, request| "/gamsat-preparation-courses/attendance-complete-care?#{request.params.to_query}"}
  get '/umat-preparation-courses/online', to: redirect{ |params, request| "/umat-preparation-courses/online-comprehensive?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/interviewready-comprehensive', to: redirect{ |params, request| "/gamsat-preparation-courses/interview-attendance-comprehensive?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/interviewready-essentials', to: redirect{ |params, request| "/gamsat-preparation-courses/interview-attendance-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/interviewready-online-essentials', to: redirect{ |params, request| "/gamsat-preparation-courses/interview-online-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/1-week-trial', to: redirect{ |params, request| "/gamsat-preparation-courses/free-trial?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/attendence', to: redirect{ |params, request| "/gamsat-preparation-courses/attendance-comprehensive?#{request.params.to_query}"}

  get '/umat-preparation-courses/courses-oe', to: redirect{ |params, request| "/umat-preparation-courses/online-essentials?#{request.params.to_query}"}
  get '/umat-preparation-courses/courses-oc', to: redirect{ |params, request| "/umat-preparation-courses/online-comprehensive?#{request.params.to_query}"}
  get '/umat-preparation-courses/courses-ae', to: redirect{ |params, request| "/umat-preparation-courses/attendance-essentials?#{request.params.to_query}"}
  get '/umat-preparation-courses/courses-ac', to: redirect{ |params, request| "/umat-preparation-courses/attendance-comprehensive?#{request.params.to_query}"}
  get '/umat-preparation-courses/courses-cc', to: redirect{ |params, request| "/umat-preparation-courses/attendance-complete-care?#{request.params.to_query}"}

  get '/gamsat-preparation-courses/courses-oe', to: redirect{ |params, request| "/gamsat-preparation-courses/online-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/courses-oc', to: redirect{ |params, request| "/gamsat-preparation-courses/online-comprehensive?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/courses-ae', to: redirect{ |params, request| "/gamsat-preparation-courses/attendance-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/courses-ac', to: redirect{ |params, request| "/gamsat-preparation-courses/attendance-comprehensive?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/courses-cc', to: redirect{ |params, request| "/gamsat-preparation-courses/attendance-complete-care?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/courses-ire', to: redirect{ |params, request| "/gamsat-preparation-courses/interview-attendance-essentials?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/courses-irc', to: redirect{ |params, request| "/gamsat-preparation-courses/interview-attendance-comprehensive?#{request.params.to_query}"}

  get '/umat-preparation-courses/online-basic-5e64c230-6be0-4d7d-948a-4338a900b0af', to:  redirect{ |params, request| "/umat-preparation-courses/online-essentials?#{request.params.to_query}"}
  get '/umat-preparation-courses/online-44383c37-9593-4bba-8be2-23f6f123ce15', to: redirect{ |params, request| "/umat-preparation-courses/online-comprehensive?#{request.params.to_query}"}
  get '/umat-preparation-courses/ucatready-attendence-essentials', to: redirect{ |params, request| "/umat-preparation-courses/attendance-essentials?#{request.params.to_query}"}
  get '/umat-preparation-courses/attendence', to: redirect{ |params, request| "/umat-preparation-courses/attendance-comprehensive?#{request.params.to_query}"}
  get '/umat-preparation-courses/attendence-all-84386da2-92e7-4267-9912-f34e31a81a59', to: redirect{ |params, request| "/umat-preparation-courses/attendance-complete-care?#{request.params.to_query}"}
  get '/umat-preparation-courses/custom-5905ac7d-219c-4c96-8708-7d4655ab563c', to: redirect{ |params, request| "/umat-preparation-courses/custom?#{request.params.to_query}"}
  get '/umat-preparation-courses/ucat-free-trial', to: redirect{ |params, request| "/umat-preparation-courses/free-trial?#{request.params.to_query}"}
  get '/gamsat-preparation-courses/events', to: redirect{ |params, request| "/posts/free-gamsat-events"}
  get '/blog', to: redirect('/blog/gamsat-preparation-courses')
  
  
  
  get 'tags/get_tag_tutors' => 'tag_search#get_tag_tutors'
  get 'tags/ticket_transfer_tags' => 'tag_search#ticket_transfer_tags'
  get 'tags/append' => 'tag_search#append'

  resources :tags, except: [:show] do
    collection do
      get :search
      get :root_tags
      get :ticket_tags
      get :children_for_tags
      
      
    end
    member do
      get 'children_for_tag'
      get 'answerer_for_tag'
      get 'mcq_stem_review_videos'
    end
  end
  
  

  scope '/admin' do
    resources :product_versions do
      member do
        put :push_in_archived
        put :pull_from_archived
        get :product_version_courses
      end
      collection do
        get :archived_product_versions
      end
    end
    resources :faq_pages, except: [:new, :show], type: 'gamsat'
    resources :announcements
    resources :event_dates
    resources :public_updates
    resources :admin_controls, only: [:index, :edit, :update, :show]
    resources :exit_pop_ups
  end

  root 'pages#main'
  mount Ckeditor::Engine => '/ckeditor'
  mount Commontator::Engine => '/commontator'
  mathjax 'mathjax'

  get 'announcements/get_versions_and_features'
  get 'events/index'
  get 'student_answer_summary/index'
  get 'areas/create'
  get 'events/show'
  get 'events/destroy'
  get 'blog/:blog' => 'posts#blog_posts', as: :blog_posts
  get 'blog/:blog/:category' => 'posts#index', as: :posts_by_category

  resources :blog_categories, except: [:show]
  resources :posts
  get 'posts/:type/:id' => 'posts#show', as: :posts_by_product_line

  get ':type/faq' => 'faq_pages#dashboard', as: :faq

  get ':type/faq/:topic' => 'faq_pages#show_topic', as: :faq_topic
  get 'faq_page/url_by_topic' => 'faq_pages#page_url_by_topic', as: :faq_page_url_by_topic

  resources :tutor_availabilities
  resources :tutor_schedules do
    member do
      get :availabilities
    end
  end

  resources :documents do
    get 'access', on: :member
    member do
      get :document_feedback
      get :download_file
      get :download_essential_file
      get :download_comprehensive_file
      get :download_weekend_course_file
      get :download_other_comprehensive_file
    end
    collection do
      get 'filter_topics'
    end
  end

  resources :textbooks, except: [:show] do
    member do
      get :textbook_document
      get :exercise_review_videos
      get :textbook_feedback
      get :timetable
      get :download_timetable
      get :print_count
      get :reset_access
      get :update_print_access
    end
  end
  resources :textbooks, only: [:show], :constraints => {:format => /(html|js|json)/}

  resources :video_categories
  resources :vods, path: 'videos' do
    collection do
      get 'filter_tags'
    end
    member do
      get :exercise_review_textbooks
      get :vod_feedback
      get :download
    end
  end

  resources :live_exams
  resources :mock_essays do
    member do
      get :download_file
    end
    resources :mock_essay_feedbacks
  end
  resources :mock_exam_essays do
    member do
      get :feedbacks
      post :update_tutor
      get :assign_tutor
    end
    collection do
      post :mass_update_tutor
    end
  end

  resources :appointments do
    get 'make', on: :collection
    get 'escalate_appointment_issue' , on: :member
  end

  resources :student_class_sessions
  resources :student_classes
  resources :areas
  resources :marks, only: [:index]
  resources :tag
  resources :stripe_purchases, only: :create
  resources :paypal_purchases, only: :create

  resources :purchases do
    post :details, on: :collection
  end

  resources :product_packages do
    post :delete_products
  end

  post 'purchase_product' => 'purchase#product', as: :purchase_product
  get 'purchase' => 'purchase#additional_features_form', as: :purchase_form

  resources :student_classes do
    delete 'remove_student'
  end

  scope '/ticketing' do
    get 'forum/(:id)' => 'issue_forum#list', :as => :issues
    get 'issue/(:id)' => 'issue_forum#show', :as => :issue
    get 'get_clarity' => 'issue_forum#get_clarity', as: :get_clarity
  end

  get 'essay_responses/to_mark' => 'essay_responses#to_mark'
  get 'essay_responses/tutor_essays' => 'essay_responses#tutor_essays'
  get 'essay_responses/filtered_tutor_essays' => 'essay_responses#filtered_tutor_essays'
  get 'essay_responses/download_tutor_essays' => 'essay_responses#download_tutor_essays'
  resources :essay_responses do
    member do
      post :update_tutor
      get :assign_tutor
    end
    collection do
      get :download_marked_essays
      post :mass_update_tutor
      post :update_essays_tutor
    end
    post :submit
    resources :essay_tutor_responses
    resources :essay_tutor_feedbacks
  end

  resources :essays do
    get 'student_answer'
    post 'student_answer' => 'essays#collectsubmit_essay_response_student_answer', :as => :collect_student_answer
    get 'tutor_rate'
    post 'tutor_rate' => 'essays#collect_tutor_rate', :as => :collect_tutor_rate

    collection do
      post :update_product_line_positions
      get 'filter_essays'
      get 'tag_filter'
    end
  end

  resources :essay_tutor_responses, only: [:index]

  namespace :surveys do
    resources :survey_answers
    resources :surveys do
      get 'fill'
      post 'fill' => 'surveys#filled', :as => :filled
    end
    resources :survey_questions
  end

  get 'mcq_stems/:id/log_hours' => 'mcq_hours#index', as: :mcq_hours
  post 'mcq_stems/:id/create_mcq_hour' => 'mcq_hours#create', as: :create_mcq_hour
  delete 'mcq_stems/:id/delete_last_mcq_hour' => 'mcq_hours#destroy', as: :delete_mcq_hour

  get '/mcq_stems/payment_data' => 'mcq_payment_data#payment_data', as: :payment_data
  get '/mcq_stems/payment_data_all' => 'mcq_payment_data#payment_data_all', as: :payment_data_all

  resources :mcq_stems, except: [:index] do
    get :mcq_unit_progress_dashboard, on: :collection
    get :mcq_creation_progress_statistics, on: :collection
    member do
      post 'change_work_status'
      get 'change_examinable'
      post 'update_complete_time'
      get "total_rating"
      post 'update_work_status'
      post 'update_pool'
      post 'update_reviewer1'
      post 'update_reviewer2'
      post 'update_video_explainer'
      post 'update_video_reviewer'
    end
    resources :mcqs do
      collection do
        post 'complete_stem'
      end
    end
  end


  get 'statistic/mcq/difficulty' => 'statistic#by_difficulty', as: :mcq_by_difficulty
  get 'statistic/mcq/tags' => 'statistic#all_tags', as: :all_tags
  get 'statistic/mcq_stem/index' => 'statistic#mcq_stem_difficulty', as: :statistics_mcq_stem
  get 'statistic/mcq/index' => 'statistic#mcq_difficulty', as: :statistics_mcq

  resources :courses do
    resources :course_versions
    get :create_new_version
    get :custom_version
    post :submit_custom_version
    collection do
      post :update_paypal
    end
  end

  get 'sign_on_course/:id' => 'course_versions#sign_on_course', as: :sign_on_course
  get 'sign_out_from_course/:id' => 'course_versions#sign_out_from_course', as: :sign_out_from_course

  resources :subjects do
    resources :student_questions
    collection do
      get 'list_for_course/:course_version_id' => 'subjects#list_for_course', as: 'list_for_course'
    end
  end

  delete 'active_subject/:id' => 'subjects#delete_active_subjects', as: 'active_subject'

  namespace :managers do
    get 'home'
  end

  # get 'tutor_appointments/:tutor_id' => 'dashboard#tutor_appointments', as: :tutor_appointments
  get 'dashboard/:student_id/book_tutor' => 'dashboard#book_tutor', as: :admin_book_tutor
  namespace :dashboard do
    get 'home'
    get 'student'
    get 'time_remaining'
    get 'surveys'
    get 'courses'
    get 'events'
    # get 'essays'
    get 'create_mcqs'
    get 'mcq_stems'
    get 'vods'
    get 'textbooks'
    get 'book_tutor'
    get 'count_tutor_appointments'
    get 'purchase_addons'
    get 'unresolved_issues'
    get 'student_enrolments'
    get 'filtered_tutors'
    get 'purchase_summary'
    get 'admin' => 'dashboard#admin'
    get 'update_tutors_select', as: 'update_tutors_select'
    get 'mcq_counter'
    get 'published_filter_mcq_counter'
    get 'staff_answered_questions'
    get 'important_dates'
    get 'calender'
    get 'upgrade'
    get 'hide_announcement'
    get 'filtered_topics'
    get 'mock_exam_essays'
    get 'no_access'
    get 'online_mock_exam_essays'

    resources :essays do
      resources :essay_responses, only: [:create, :edit, :new, :update, :show] do
        post :submit
      end
    end
    resources :mcq_stems
    get :manage_mcqs
  end

  namespace :student_answer do
    post :mcq_stem
    get :mcqs
    post :mcqs
    get :mcq_stem
  end

  resources :orders, only: [:index, :show] do
    collection do
      get :client_token
    end

    member do
      post :empty_cart, as: 'empty_cart'
      post :paypal_complete, as: 'paypal'
      post :direct_complete, as: 'direct_deposit'
      post :confirm_paid, as: 'confirm_paid'
      post :add_promo, as: 'add_promo'
      delete :remove_promo, as: 'remove_promo'
      post :share_promo_code, as: 'share_promo_code'
      post :redact_order, as: 'redact_order'
      get :payment_success
      post :add_to_cart
      post :textbook_cart
      get :invoice_pdf
    end
  end

  get '/orders/discount/:token' => 'orders#promo_link', as: 'user_promo_link'
  get '/display_pending_orders' => 'orders#display_pending'

  resources :high_schools, only: [:index]
  resources :purchase_items, only: [:destroy]
  get '/promos/used_promos' => 'promos#used_promos'
  resources :promos

  resources :staff_profiles, only: [:index] do
    get :search, on: :collection
    get :append, on: :collection
  end

  # resources :featurettes, only: [:index, :show, :destroy]
  resources :feature_logs, only: [:index, :show, :destroy, :update] do
    get :find_feature_price, on: :member
    get :find_pv_price, on: :member
    get :purchase_mcqs, on: :collection
    get :pvfp_qty_price, on: :member
  end
  # get 'featurettes/:id/add_to_cart' => 'featurettes#add_to_cart', as: :add_feature_cart
  get 'feature_logs/:id/add_to_cart' => 'feature_logs#add_to_cart', as: :add_feature_cart
  put 'promo_unsubscribe' => 'orders#unsubscribe_popup', as: :promo_unsubscribe
  get '/gamsat-preparation-courses/student_testimonials' => 'pages#gamsat_student_testimonials'
  get '/gamsat-preparation-courses/our_students' => 'pages#gamsat_our_students'

  get '/umat-preparation-courses/our_students' => 'pages#umat_our_students'
  get '/umat-preparation-courses/student_testimonials' => 'pages#umat_student_testimonials'

  get '/hsc/our_students' => 'pages#hsc-our_students'
  get '/hsc/student_testimonials' => 'pages#hsc-student_testimonials'

  get '/vce/our_students' => 'pages#vce-our_students'
  get '/vce/student_testimonials' => 'pages#vce-student_testimonials'

  get '/gamsat-preparation-courses/interviewready/interviewready-essential' => 'pages#gamsat-interviewready-essential'
  get '/gamsat-preparation-courses/interviewready/interviewready-comprehensive' => 'pages#gamsat-interviewready-comprehensive'

  get '/what-is-ucat' => 'pages#what_is_ucat'
  get '/ucat-preparation' => 'pages#ucat_preparation'
  get '/ucat-structure' => 'pages#ucat_structure'
  get '/ucat-parents-guide' => 'pages#ucat_parents_guide'
  get '/ucat-students-guide' => 'pages#ucat_students_guide'
  get '/ucat-vs-gamsat' => 'pages#ucat_vs_gamsat'
  get '/ucat-dentistry' => 'pages#ucat_dentistry'

  get '/what-is-gamsat' => 'pages#what_is_gamsat'
  get '/gamsat-2022' => 'pages#gamsat_2022'
  get '/gradready-partners' => 'pages#gamsat_partners'
  get '/gamsat-study-schedule' => 'pages#gamsat_study_schedule'
  get '/gamsat-physics-formula-sheet' => 'pages#gamsat_physics_formula_sheet'
  get '/gamsat-study-syllabus' => 'pages#gamsat_study_syllabus'

  get '/gamsat-free-practice' => 'pages#gamsat_free_practice'
  get '/gamsat-example-essay' => "pages#gamsat_example_essay"
  get '/medical-school-entry-requirements' => 'pages#medical_school_entry_requirements'
  get '/australian-medical-schools' => 'pages#australian_medical_schools'
  get '/how-to-become-a-doctor' => 'pages#pathways_to_medicine'
  get '/gamsat-textbooks' => 'pages#gamsat_textbooks'
  get '/gamsat-scores' => 'pages#gamsat_scores'
  get '/gamsat-quote-generator' => 'pages#gamsat_quote_generator'

  get '/updates' => 'pages#recent_update', as: 'recent_update'

  get 'gamsat-preparation-courses/scholarship' => 'pages#gamsat_scholarship'
  get 'gamsat-preparation-courses/principal_scholarship' => 'pages#gamsat_principal'
  get 'gamsat-preparation-courses/access-program' => 'pages#gamsat_access_program'
  get 'gamsat-preparation-courses/compare' => 'pages#gamsat-compare_gradready'
  get 'gamsat-preparation-courses/overview' => 'pages#gamsat_about'

  get 'pages/set_footer' => 'pages#set_footer'

  get 'pages/download_gamsat_pdf' => 'pages#download_gamsat_pdf'
  get 'pages/download_ucat_pdf' => 'pages#download_umat_pdf'

  get 'umat-preparation-courses/scholarship' => 'pages#umat_scholarship'
  get 'umat-preparation-courses/principal_scholarship' => 'pages#umat_principal'
  get 'umat-preparation-courses/compare' => 'pages#umat-compare_umatready'
  get 'umat-preparation-courses/about' => 'pages#umat_about'
  get 'umat-preparation-courses/access-program' => 'pages#umat_access_program'

  get 'vce/scholarship' => 'pages#vce-scholarship'
  # get 'vce/access-program' => 'pages#vce-access-program'
  get 'vce/compare' => 'pages#vce-compare'
  get 'vce/about' => 'pages#vce-about'

  match '/gamsat' => redirect('/gamsat-preparation-courses'), via: :all
  match '/ucat' => redirect('/umat-preparation-courses'), via: :all

  get 'hsc/scholarship' => 'pages#hsc-scholarship'
  # get 'hsc/access-program' => 'pages#hsc-access-program'
  get 'hsc/compare' => 'pages#hsc-compare'
  get 'hsc/about' => 'pages#hsc-about'
  get 'umat-preparation-courses/team' => 'pages#team'
  get 'hsc/team' => 'pages#team'
  get 'vce/team' => 'pages#team'
  get 'gamsat-preparation-courses/team' => 'pages#team'
  post 'show_course_recommender' => 'pages#show_course_recommender'
  get 'hsc' => 'pages#hsc'
  get 'vce' => 'pages#vce'
  get 'gamsat-preparation-courses' => 'pages#gamsat'
  get 'umat-preparation-courses' => 'pages#umat'
  get 'contact' => 'contact#index'
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'
  get 'about' => redirect('gamsat/overview')
  get 'faq' => 'pages#faq'
  get 'gamsat-preparation-courses/contact' => 'contact#index', product_line: 'gamsat'
  get 'vce/contact' => 'contact#index', product_line: 'vce'
  get 'hsc/contact' => 'contact#index', product_line: 'hsc'

  get 'umat-preparation-courses/contact' => 'contact#index', product_line: 'umat'
  get 'profile' => 'users#show'
  get '/title' => 'dashboard#course'
  get 'mark_essay_response' => 'mark_essay_responses#new'
  get 'events/index'
  get 'events/show'
  get 'events/destroy'
  get 'areas/create'
  post 'contact_form/' => 'contact#create_inquire', as: 'contact_forms'
  post 'team' => 'pages#team'
  post 'mark_essay_response' => 'mark_essay_responses#create'
  get 'paypal_test' => 'paypal_purchases#test'
  get 'paypal_execute' => 'paypal_purchases#execute_payment'
  get 'paypal_cancel' => 'paypal_purchases#cancel'
  get "/job_application_forms/available_positions" => redirect("/jobs/available_positions")
  get 'textbook_url/:id' => 'textbook_url#download', as: 'textbook_url'
  get 'document_url/:id' => 'documents#download', as: 'document_url'

  get 'download_file/:id' => 'textbook_url#download_file', as: 'download_file'
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/422", :to => "errors#unprocessable_error", :via => :all
  get 'gamsat-preparation' => 'pages#gamsat_preparation'
  get 'gamsat-section-1' => 'pages#gamsat_section_1'
  get 'gamsat-section-2' => 'pages#gamsat_section_2'
  get 'gamsat-section-3' => 'pages#gamsat_section_3'
  get '/free-gamsat-preparation-materials' => 'pages#gamsat_free_resources'
  get 'gamsat-biology' => 'pages#gamsat_biology'
  get 'gamsat-chemistry' => 'pages#gamsat_chemistry'
  get 'gamsat-physics' => 'pages#gamsat_physics'
  get 'gamsat-non-science-background' => 'pages#gamsat_non_science_background'

  if Rails.env.production?
    match ENV['GOOGLE_VERIFY_PAGE'], :to => "pages#google_verify_page", :via => :all
  end

  post '/subscribe/:list' => 'mailing_list_subscriptions#create', as: :mailing_list_subscribe
  get '/unsubscribe/:list' => 'mailing_list_subscriptions#destroy', as: :mailing_list_unsubscribe

  scope '/gamsat-preparation-courses' do
    scope '/admin' do
      resources :faq_pages, except: [:new, :show], as: :gamsat_admin_faq_pages, type: 'gamsat'
    end
    get '/privacy' => 'pages#privacy'
    get '/terms' => 'pages#terms'
    get '/team' => 'pages#team'
    # get '/pricing' => 'pages#gamsat-pricing'
    get '/online_system_demo' => 'pages#gamsat-online_system_demo'
    resources :gamsat_readies, path: "/"
  end

  scope '/umat-preparation-courses' do
    get '/free_resources' => 'pages#umat_free_resources'
    resources :umat_readies, path: "/"
    scope '/admin' do
      resources :faq_pages, except: [:new, :show], as: :umat_admin_faq_pages, type: 'umat'
    end
    get '/privacy' => 'pages#privacy'
    get '/terms' => 'pages#terms'
    get '/team' => 'pages#team'
  end

  scope '/vce' do
    resources :vce_readies, path: "/"
    scope '/admin' do
      resources :faq_pages, except: [:new, :show], as: :vce_admin_faq_pages, type: 'vce'
    end
    get '/terms' => 'pages#terms'
    get '/privacy' => 'pages#privacy'
    get '/team' => 'pages#team'
  end

  scope '/hsc' do
    resources :hsc_readies, path: "/"
    scope '/admin' do
      resources :faq_pages, except: [:new, :show], as: :hsc_admin_faq_pages, type: 'hsc'
    end
    get '/terms' => 'pages#terms'
    get '/privacy' => 'pages#privacy'
    get '/team' => 'pages#team'
  end

  authenticated :user, -> (user) { user.admin? || user.superadmin? } do
    mount ActiveRecordProfiler::Engine => "/profiler"
  end
  resources :mcq_attempts, only: [:destroy]

  get '/thankyou/gamsattrial' => 'thankyou#gamsattrial'
  get '/thankyou/umattrial' => 'thankyou#umattrial'
  get '/thankyou/umat' => 'thankyou#umat'
  get '/thankyou/gamsat' => 'thankyou#gamsat'
  get '/thankyou/ir' => 'thankyou#ir'
  get '/thankyou/ir' => 'thankyou#ir'
  get '/thankyou/unsubscribe' => 'thankyou#unsubscribe'

  get 'ui_guide.html', to: 'guide#index', defaults: { format: 'html' }
  get 'sitemap.html', to: 'sitemap#index', defaults: { format: 'html' }
  # resources :performance_stats

  resources :performance_stats, only: [:create, :update]

  get 'download/gamsat_study_schedule.jpg' => 'pages#gam_study_schedule', as: :'download/gamsat_schedule'
  get 'download/physics_formula_sheet' => 'pages#physics_formula_sheet', as: :'download/phy_formula_sheet'
  get 'download/gam_study_syllabus' => 'pages#gam_study_syllabus', as: :'download/gam_study_syllabus'
  get 'download/gradready_gamsat_essay_writing_guide' => 'pages#essay_writing_guide', as: :'download/gradready_gamsat_essay_writing_guide'

  get 'gaw-shopping-ad/textbook', to: 'gaw#textbook'
  get 'gaw-shopping-ad/online_exams', to: 'gaw#online_exams'
  get 'gaw-shopping-ad/marked_essays', to: 'gaw#marked_essays'
  get 'gaw-shopping-ad/mcq_bank', to: 'gaw#mcq_bank'
  get 'gaw-shopping-ad/private_tuition_sessions', to: 'gaw#private_tuition_sessions'
  get 'gaw-shopping-ad/mock_exam', to: 'gaw#mock_exam'
  get 'gaw-shopping-ad/online_essentials', to: 'gaw#online_essentials'
  get 'gaw-shopping-ad/online_comprehensive', to: 'gaw#online_comprehensive'
  get 'gaw-shopping-ad/attendance_essentials', to: 'gaw#attendance_essentials'
  get 'gaw-shopping-ad/attendance_comprehensive', to: 'gaw#attendance_comprehensive'
  get 'gaw-shopping-ad/attendance_complete_care', to: 'gaw#attendance_complete_care'


  get 'gaw-shopping-ad/online_essentials-2', to: 'gaw#online_essentials'
  get 'gaw-shopping-ad/online_comprehensive-2', to: 'gaw#online_comprehensive'
  get 'gaw-shopping-ad/attendance_essentials-2', to: 'gaw#attendance_essentials'
  get 'gaw-shopping-ad/attendance_comprehensive-2', to: 'gaw#attendance_comprehensive'
  get 'gaw-shopping-ad/attendance_complete_care-2', to: 'gaw#attendance_complete_care'
  get 'gaw-shopping-ad/mcq_bank-2', to: 'gaw#mcq_bank'
  get 'gaw-shopping-ad/mcq_bank-3', to: 'gaw#mcq_bank'
  get 'gaw-shopping-ad/mcq_bank-4', to: 'gaw#mcq_bank'
  get 'gaw-shopping-ad/mcq_bank-5', to: 'gaw#mcq_bank'
  get 'gaw-shopping-ad/marked_essays-2', to: 'gaw#marked_essays'
  get 'gaw-shopping-ad/private_tuition_sessions-2', to: 'gaw#private_tuition_sessions'

  resources :course_pages
  resources :last_min_courses
  resources :notifications, except: [:new, :show]
  resources :manual_email_announcements do
    collection do
      get 'courses'
      get 'duplicate'
      get 'manually_fire_emails'
    end
  end
  get '/gamsat-podcast' => 'podcasts#index', as: :podcasts
  get '/gamsat-podcast/:id' => 'podcasts#show', as: :podcasts_show
  post '/mcq_attempts/:id/update_flagged' => 'mcq_attempts#update_flagged'
  post '/mcq_attempts/update_selected_attempt' => 'mcq_attempts#update_selected_attempt'
  get '/mcq_attempts/get_question_list' => 'mcq_attempts#get_question_list'
  post '/mcq_attempts/:id/update_attempt_answer' => 'mcq_attempts#update_attempt_answer'
  match '/product_versions/:id' => 'product_versions#update', via: [:patch, :put]
  post '/product_versions' => 'product_versions#create'

  resources :email_deliveries do
    collection do
      get 'get_all_deliveries'
      get 'download_email'
      get 'download_email_text'
    end
  end
  resources :autoemails
  get '/mark-book-read' => 'textbooks#mark_book_read'
  post '/mcq_vid' => 'mcq_attempts#create_user_video'
  match "*path" => redirect("/404"), :via => :all

end

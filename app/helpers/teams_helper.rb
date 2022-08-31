module TeamsHelper
  def tutor_profile(options, &block)
    options[:tutor_info] = capture &block
    render 'pages/partial/tutor_profile', options
  end
end

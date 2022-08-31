# Helper for vods
module VodsHelper
  def tab_active_class(tab, tag, index)
    if tab.present?
      tab == tag.name.split.drop(1).join(' ') ? 'active' : ''
    elsif index == 0
      'active'
    end
  end
end

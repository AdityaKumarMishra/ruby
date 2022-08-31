module SectionAttemptHelper
  def tag_level(tag)
    level = 0
    leaf_tag = 0
    leaf_tag += 1 unless Tag.where(parent_id: tag.id).count > 0
    until tag.parent.nil?
      tag = tag.parent
      level += 1
    end
    [level, leaf_tag]
  end

  def percentile_level_row_style(level, leaf_tag, score)
    score = score.to_i
    background_color = 0x999999 + (0x222222 * level)
    if leaf_tag >= 0
      if score >= 0 && score < 50
        background_color = 0xEA9999
      elsif score >= 50 && score < 70
        background_color = 0xFFE599
      elsif score >= 70 && score <= 100
        background_color = 0xDAF7A6
      end
    end
    "background-color: ##{background_color.to_s(16)};"
  end


end

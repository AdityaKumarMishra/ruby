class MakeMcqStemsUnique < ActiveRecord::Migration[6.1]
  # Make all mcq titles unique
  def change
    McqStem.all.each do |stem|
      McqStem.where(title: stem.title).each_with_index do |clash, i|
        if clash != stem
          clash.title += " (#{i})"
          clash.save
        end
      end
    end
  end
end

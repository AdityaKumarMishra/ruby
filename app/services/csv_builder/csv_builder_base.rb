module CsvBuilder
  class CsvBuilderBase
    attr_accessor :data, :output

    def initialize(data, output)
      @output = output
      @data = data
    end

    def columns_mapping
      raise StandardError, 'Needs to be implemented in child class'
    end

    def record_row_data(record)
      columns_mapping.keys.map do |column|
        if(column == :course)
          record.courses.pluck(:name).uniq.join(', ')
        elsif(column == :product_version)
          record.product_versions.pluck(:name).uniq.join(', ')
        elsif (column == :first_payment)
          (Time.zone.now.to_date - record.paid_enrolments.order(:paid_at).first.created_at.to_date).to_i if record.paid_enrolments.present?
        elsif (column == :enrolment_date)
          en_date = record.paid_enrolments.order(:created_at).last.try(:created_at)
          en_date.to_date if en_date
        else
          record.public_send(column)
        end
      end
    end

    def call
      output << (columns_mapping.values).to_csv
      data.find_each do |record|
        output << record_row_data(record).to_csv
      end
    end
  end
end

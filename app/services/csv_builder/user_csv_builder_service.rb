module CsvBuilder
  class UserCsvBuilderService < CsvBuilderBase
    def columns_mapping
      {
        id: 'User id',
        email: 'Email',
        first_name: 'First name',
        last_name: 'Last Name',
        username: 'Usermane',
        slug: 'Slug',
        phone_number: 'Phone',
        uid: 'Uuid',
        role: 'User role',
        area: 'Area',
        status: 'Status',
        line_one: 'Address line 1',
        line_two: 'Address line 2',
        suburb: 'Suburb',
        post_code: 'Postcode',
        state: 'State',
        country: 'Country',
        course: 'Course Name',
        first_payment: 'Number of days since payment',
        enrolment_date: 'Course enrolment dates',
        last_source: 'Last source',
        product_version: 'Product Version',
        student_level: 'Student level',
        highschool_year_level: 'High school year level',
        target_uni_course: 'Target uni course',
        current_highschool: 'Current highschool',
        university: 'University',
        degree: 'Degree'
      }
    end
  end
end

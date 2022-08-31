module ProductVersionsHelper
  # def feature_list
  #   features = [['Select the feature', '']]
  #   Dir.foreach("#{Rails.root}/app/models/features") do |m|
  #     next unless m.include?('.rb')
  #     feature_class = m.chomp('.rb').camelize.constantize
  #     features.push([feature_class, feature_class])
  #   end
  #   features
  # end

  # commenting code code due to slug
  # def gamsat_improvment_scores
  #   {
  #     'online-basic': {
  #       from: 59.9,
  #       to:  66.7,
  #       percentile_from: "59th",
  #       percentile_to: "85th"
  #     },
  #     'online': {
  #       from: 58.2,
  #       to: 62.4,
  #       percentile_from: "48th",
  #       percentile_to: "70th"
  #     },
  #     'attendence-basic': {
  #       from: 58.9,
  #       to: 64.5,
  #       percentile_from: "50th",
  #       percentile_to: "80th"
  #     },
  #     'attendence-d4588d4f-d803-4a68-8b06-06c2af9406ee': {
  #       from: 58.5,
  #       to: 63.9,
  #       percentile_from: "48th",
  #       percentile_to: "74th"
  #     },
  #     'attendence-all': {
  #       from: 56.8,
  #       to: 62.7,
  #       percentile_from: "40th",
  #       percentile_to: "71st"
  #     }
  #   }
  # end

  def recreate_pvfps(pvfps, product_version)
    pvfps.map do |pvfp|
      custom_feature_qty = pvfp.master_feature.custom_feature_qty(pvfp.qty, product_version.try(:type))

      if (custom_feature_qty != nil && custom_feature_qty > 1)
        new_pvfp = ProductVersionFeaturePrice.find_or_create_by(pvfp.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :price, :qty, :subtype_change_date, :is_additional).merge(qty: custom_feature_qty, price: (pvfp.price * (custom_feature_qty || 1).to_i), is_additional: true))
        new_pvfp.tags << pvfp.tags
        new_pvfp.save!
        new_pvfp
      else
        pvfp
      end
    end
  end

  def gamsat_improvment_scores
    {
      '4': {
        from: 59.9,
        to:  66.7,
        percentile_from: "59th",
        percentile_to: "85th"
      },
      '5': {
        from: 58.2,
        to: 62.4,
        percentile_from: "48th",
        percentile_to: "70th"
      },
      '6': {
        from: 58.9,
        to: 64.5,
        percentile_from: "50th",
        percentile_to: "80th"
      },
      '7': {
        from: 58.5,
        to: 63.9,
        percentile_from: "48th",
        percentile_to: "74th"
      },
      '8': {
        from: 56.8,
        to: 62.7,
        percentile_from: "40th",
        percentile_to: "71st"
      }
    }
  end

  def umat_improvment_scores
    {
      '4': {
        from: 59.9,
        to:  66.7,
        percentile_from: "59th",
        percentile_to: "85th"
      },
      '5': {
        from: 58.2,
        to: 62.4,
        percentile_from: "48th",
        percentile_to: "70th"
      },
      '6': {
        from: 58.9,
        to: 64.5,
        percentile_from: "50th",
        percentile_to: "80th"
      },
      '7': {
        from: 58.5,
        to: 63.9,
        percentile_from: "48th",
        percentile_to: "74th"
      },
      '8': {
        from: 56.8,
        to: 62.7,
        percentile_from: "40th",
        percentile_to: "71st"
      }
    }
  end

  def gamsat_product_info
    {
      'online-basic' => {
        extra_prac_material: false,
        live_component: true,
        targeted_tutor: false,
        price: ProductVersion.find_by(slug: "online-basic").price,
        video: true,
        early_bird: ProductVersion.find_by(slug: "online-basic").early_bird,
        component_value: 979
      },
      'online' => {
        extra_prac_material: true,
        live_component: true,
        targeted_tutor: true,
        price: ProductVersion.find_by(slug: "online").price,
        video: true,
        early_bird: ProductVersion.find_by(slug: "online").early_bird,
        component_value: 1632
      },
      'attendance-basic' => {
        extra_prac_material: false,
        extra_live_component: false,
        live_component: true,
        targeted_tutor: false,
        price: ProductVersion.find_by(slug: "attendence-basic").price,
        video: true,
        mock_exam: true,
        early_bird: ProductVersion.find_by(slug: "attendence-basic").early_bird,
        component_value: 3055
      },
      'attendance' => {
        extra_prac_material: true,
        extra_live_component: false,
        live_component: true,
        targeted_tutor: true,
        price: ProductVersion.find_by(slug: "attendence-d4588d4f-d803-4a68-8b06-06c2af9406ee").price,
        video: true,
        mock_exam: true,
        early_bird: ProductVersion.find_by(slug: "attendence-d4588d4f-d803-4a68-8b06-06c2af9406ee").early_bird,
        component_value: 3493
      },
      'attendance-all' => {
        extra_prac_material: true,
        extra_live_component: true,
        live_component: true,
        targeted_tutor: true,
        price: ProductVersion.find_by(slug: "attendence-all").price,
        video: true,
        mock_exam: true,
        early_bird: ProductVersion.find_by(slug: "attendence-all").early_bird,
        component_value: 4254
      },
      'interviewready-online-essentials' => {
        live_component: false,
        price: ProductVersion.find_by(slug: "interviewready-online-essentials").try(:price),
        early_bird: ProductVersion.find_by(slug: "interviewready-online-essentials").early_bird
      },
      'interviewready-attendance-essentials' => {
        live_component: true,
        price: ProductVersion.find_by(slug: "interviewready-essentials").try(:price),
        early_bird: ProductVersion.find_by(slug: "interviewready-essentials").early_bird
      },
      'interviewready-attendance-comprehensive' => {
        live_component: true,
        price: ProductVersion.find_by(slug: "interviewready-comprehensive").try(:price),
        early_bird: ProductVersion.find_by(slug: "interviewready-comprehensive").early_bird
      },
      'starter' => {
        price: ProductVersion.find_by(slug: "gamsat-starter").try(:price),
        early_bird: ProductVersion.find_by(slug: "gamsat-starter").early_bird
      },
      'success-assured' => {
        price: ProductVersion.find_by(slug: 'success-assured').try(:price)
      },
    }
  end

  def umat_product_info
    {
      'online-basic' => {
        live_component: false,
        targeted_tutor: false,
        price: ProductVersion.find_by(slug: "online-basic-5e64c230-6be0-4d7d-948a-4338a900b0af").price,
        video: true,
        early_bird: ProductVersion.find_by(slug: "online-basic-5e64c230-6be0-4d7d-948a-4338a900b0af").early_bird
      },
      'online' => {
        live_component: false,
        targeted_tutor: true,
        price: ProductVersion.find_by(slug: "online-44383c37-9593-4bba-8be2-23f6f123ce15").price,
        video: true,
        early_bird: ProductVersion.find_by(slug: "online-44383c37-9593-4bba-8be2-23f6f123ce15").early_bird
      },
      'attendance-basic' => {
        extra_live_component: false,
        live_component: true,
        targeted_tutor: false,
        price: ProductVersion.find_by(slug: "umatready-attendence-essentials").price,
        video: true,
        mock_exam: true,
        early_bird: ProductVersion.find_by(slug: "umatready-attendence-essentials").early_bird
      },
      'attendance' => {
        extra_live_component: false,
        live_component: true,
        targeted_tutor: true,
        price: ProductVersion.find_by(slug: "attendence").price,
        video: true,
        mock_exam: true,
        early_bird: ProductVersion.find_by(slug: "attendence").early_bird
      },
      'attendance-all' => {
        extra_live_component: true,
        live_component: true,
        targeted_tutor: true,
        price: ProductVersion.find_by(slug: "attendence-all-84386da2-92e7-4267-9912-f34e31a81a59").price,
        video: true,
        early_bird: ProductVersion.find_by(slug: "attendence-all-84386da2-92e7-4267-9912-f34e31a81a59").early_bird
      },
      'starter' => {
        price: ProductVersion.find_by(slug: "umat-starter").try(:price),
        early_bird: ProductVersion.find_by(slug: "umat-starter").early_bird
      },
      'success-assured' => {
        price: ProductVersion.find_by(slug: 'success-assured').try(:price)
      },
    }
  end

  def vce_product_info
    {
      'online-basic' => {
        live_component: false,
        targeted_tutor: false,
        price_math: BigDecimal.new('245'),
        price_english: BigDecimal.new('245'),
        video: true
      },
      'online' => {
        live_component: false,
        targeted_tutor: true,
        price_math: BigDecimal.new('345'),
        price_english: BigDecimal.new('465'),
        video: true
      },
      'attendance-basic' => {
        extra_live_component: false,
        live_component: true,
        targeted_tutor: false,
        price_math: BigDecimal.new('535'),
        price_english: BigDecimal.new('535'),
        video: true
      },
      'attendance' => {
        extra_live_component: false,
        live_component: true,
        targeted_tutor: true,
        price_math: BigDecimal.new('635'),
        price_english: BigDecimal.new('755'),
        video: true
      },
      'attendance-all' => {
        extra_live_component: true,
        live_component: true,
        targeted_tutor: true,
        price_math: BigDecimal.new('935'),
        price_english: BigDecimal.new('1055'),
        video: true
      }
    }
  end

  def hsc_product_info
    {
      'online-basic' => {
        live_component: false,
        targeted_tutor: false,
        price_math: BigDecimal.new('345'),
        price_english: BigDecimal.new('345'),
        video: true
      },
      'online' => {
        live_component: false,
        targeted_tutor: true,
        price_math: BigDecimal.new('495'),
        price_english: BigDecimal.new('695'),
        video: true
      },
      'attendance-basic' => {
        extra_live_component: false,
        live_component: true,
        targeted_tutor: false,
        price_math: BigDecimal.new('795'),
        price_english: BigDecimal.new('795'),
        video: true
      },
      'attendance' => {
        extra_live_component: false,
        live_component: true,
        targeted_tutor: true,
        price_math: BigDecimal.new('945'),
        price_english: BigDecimal.new('1145'),
        video: true
      },
      'attendance-all' => {
        extra_live_component: true,
        live_component: true,
        targeted_tutor: true,
        price_math: BigDecimal.new('1295'),
        price_english: BigDecimal.new('1495'),
        video: true
      }
    }
  end

  def master_feature_humanize_name feature_name
    case feature_name
    when 'GamsatIRTextbookFeature'
      'GAMSAT IR Textbooks'
    when 'GamsatIRVideoFeature'
      'GAMSAT IR Videos'
    when 'GamsatIRMcqFeature'
      'GAMSAT IR MCQs'
    when 'GamsatIRDocumentsFeature'
      'GAMSAT IR Document'
    else
      feature_name.underscore.humanize.titleize if feature_name.present?
    end
  end
end

namespace :orders do
  task :remove_incomplete_purchases => :environment do
    date = Time.zone.now
    pvfps = ProductVersionFeaturePrice.where(subtype_change_date: date.midnight..date.end_of_day)

    if pvfps.present?
      Order.includes(purchase_items: :purchasable).where(status: ['ongoing']).find_each do |order|
        order.purchase_items.each do |purchase_item|
          purchasable_item = purchase_item.purchasable

          if purchase_item.destroy
            order.promos.destroy_all if order.purchase_items.empty?
            if purchase_item.purchasable_type == 'FeatureLog' && purchase_item.purchasable.present? && purchase_item.purchasable.allow_delete?
              purchasable_item.destroy
            end
          end
        end
      end
    end
  end

  task update_trial_status_to_free: :environment do
    Order.trial.update_all(status: :free)
  end

  task fix_previous_orders: :environment do
    free_trial_enrolment_ids = Course.includes(:enrolments)
                                      .where(id: ProductVersion.includes(:courses)
                                                               .where(price: 0)
                                                               .map{ |pv| pv.courses.ids.uniq }
                                                               .flatten.uniq)
                                      .map{ |c|  c.enrolments.ids.uniq }.flatten.uniq
    orders = Order.where(id: [9657, 4740, 4741, 8364, 4742, 4300, 8749, 4743, 7485, 4744, 1432, 1471, 4746, 1738, 1831, 1841, 4747, 1864, 1879, 1907, 1911, 1997, 2000, 8827, 4748, 4752, 4291, 2470, 2584, 4749, 5905, 4750, 4751, 4754, 4753, 2442, 2515, 4755, 2506, 4299, 5798, 2638, 4760, 4298, 5413, 5908, 6042, 6216, 5909, 6082, 6217, 74894, 6243, 6252, 5801, 4293, 4294, 11003, 5180, 4634, 5809, 4478, 5813, 5814, 6151, 4547, 5815, 4653, 5535, 5816, 4342, 5817, 6041, 7564, 6200, 6104, 6160, 4510, 5821, 6106, 211117, 6105, 5825, 6161, 6241, 3600, 5291, 8417, 5941, 5292, 5944, 6111, 5293, 5294, 5015, 5296, 5990, 1490, 10473, 10474, 12864, 9469, 8434, 10470, 6271, 7991, 8225, 10794, 12773, 13170, 11643, 11022, 11644, 10636, 6297, 6318, 6319, 7885, 9154, 8224, 9203, 10260, 11645, 13779, 8442, 211222, 211220, 211256, 211262, 211221, 11037, 211223, 211307, 12649, 211317, 6456, 7650, 6488, 11050, 13151, 211344, 13748, 11060, 10504, 7645, 10823, 11446, 8263, 6589, 6590, 6667, 12551, 12554, 12558, 8265, 10374, 12953, 6635, 12553, 6680, 10372, 11574, 6663, 8283, 10324, 211442, 8925, 12552, 8284, 9769, 8287, 6794, 6775, 6740, 9310, 8300, 11805, 8686, 12559, 11709, 11105, 10711, 211542, 8304, 8076, 13043, 6943, 6957, 211604, 10426, 12571, 11106, 12573, 7033, 2786, 7149, 7152, 211623, 7250, 21468, 11707, 10866, 10867, 11716, 7707, 9397, 11717, 11718, 8342, 14428, 13065, 13710, 8987, 12825, 13097, 12775, 13070, 12774, 13381, 10123, 11004, 13948, 12878, 13949, 14001, 9444, 45569, 102665, 21537, 102294, 14498, 23789, 24462, 14587, 14613, 14633, 25382, 100933, 45731, 42083, 14691, 21757, 102672, 75064, 21756, 14941, 43599, 45251, 15031, 37109, 15083, 42415, 37036, 15084, 15126, 15128, 15153, 15154, 37107, 37035, 15265, 37108, 37110, 102669, 42416, 15321, 15336, 15382, 42414, 15362, 15391, 26944, 15367, 15368, 26469, 15390, 15471, 15472, 102630, 26900, 102629, 15629, 15612, 15636, 15634, 15652, 15792, 15813, 15815, 15819, 22370, 33925, 15863, 15903, 42454, 15958, 102666, 16055, 16068, 16069, 16070, 16103, 16104, 16157, 102673, 16145, 16263, 16366, 176598, 37349, 16531, 75548, 16647, 16666, 16768, 16842, 22568, 22569, 17039, 17046, 17095, 17171, 17172, 17185, 17186, 17232, 17506, 42798, 17667, 17636, 17898, 35619, 35621, 17971, 17979, 17993, 18046, 18161, 18165, 44566, 18239, 18246, 18254, 18255, 18256, 18257, 18258, 18259, 18260, 18285, 18344, 18345, 18346, 18361, 18646, 18647, 18734, 19024, 19048, 19049, 19050, 23297, 19281, 23154, 19328, 19329, 90411, 43015, 41219, 41223, 19459, 19460, 19461, 19462, 19463, 19464, 19465, 19475, 19476, 31477, 44689, 20253, 20399, 20400, 20597, 20598, 20401, 20600, 20427, 20484, 20605, 31882, 20428, 20601, 20602, 20429, 20450, 20430, 20452, 20599, 20900, 20911, 38516, 20927, 39054, 21268, 21269, 21270, 21276, 21273, 21274, 21275, 45407, 169544, 45826, 179378, 180018, 90512, 90510, 90552, 90511, 180019, 124810, 124811, 177012, 101374, 169627, 177010, 177011, 46855, 46856, 46857, 46860, 170618, 101800, 47171, 47359, 101630, 77319, 47406, 47866, 47875, 180858, 77327, 176871, 104428, 177017, 177008, 177016, 176868, 77520, 90829, 170621, 176989, 177007, 181473, 181586, 177009, 180448, 105039, 91492, 104867, 177153, 177143, 141251, 177117, 141273, 141187, 141202, 105966, 141266, 141238, 181960, 141261, 141160, 171176, 141256, 141170, 126212, 177714, 141228, 141217, 127566, 171432, 51567, 171433, 126216, 171434, 105960, 126218, 182894, 126201, 171618, 182974, 126195, 126215, 126200, 126213, 178590, 177966, 178027, 178063, 184316, 172847, 172987, 93142, 178148, 185464, 178461, 107751, 186112, 108383, 108355, 146136, 108582, 167537, 108484, 178591, 178682, 178665, 108605, 58882, 173370, 173431, 147908, 173465, 173369, 108699, 179121, 109055, 109054, 188033, 82183, 109071, 173731, 62815, 62803, 62804, 62892, 83613, 62816, 62793, 62817, 62776, 62811, 62819, 62822, 62800, 62818, 62782, 62787, 62813, 62891, 62796, 62778, 62779, 62786, 62789, 62795, 62820, 62960, 169244, 95027, 174311, 174810, 174310, 191493, 64132, 95132, 174334, 85172, 110137, 110132, 110135, 64152, 64165, 64232, 110136, 174309, 64332, 65199, 174811, 65138, 174552, 190981, 65341, 65344, 65357, 65538, 190529, 190530, 175046, 65879, 65906, 66373, 66416, 66415, 66363, 66366, 66487, 66592, 66580, 175786, 193248, 193175, 175789, 67680, 197596, 196722, 68435, 69526, 69379, 69397, 69378, 176089, 70229, 70473, 70474, 198134, 198202, 155821, 70599, 70626, 71366, 198218, 198695, 71474, 198768, 199235, 176544, 199435, 199929, 99723, 199452, 124819, 73533, 124823, 100621, 124809, 100631, 201736, 201407, 124825, 74461, 124824, 100677, 74467, 202051, 90233, 202486, 124816, 124808, 202493, 203050, 203055, 74624, 74625, 203033, 90264, 202471, 203053, 203863, 203819, 204291, 204232, 203832, 203869, 203878, 204292, 204410, 205146, 204603, 204830, 204642, 205893, 205536, 205906, 207016, 207055, 207103, 207107, 207108, 207110, 207111, 208228, 208116, 208438, 208674, 208684, 208688, 208696, 208713, 208808, 208804, 208805, 208806, 208807, 208809, 208810, 208811, 208812, 208813, 208817, 208818, 208819, 208820, 208823, 209097, 209826, 209827, 209831, 209832, 209833, 209834, 209835, 209836, 209837, 209839, 209840, 209841, 209842, 209844, 209845, 209846, 209847, 209848, 209849, 209850, 209851, 209852, 209961, 209975, 209974, 209976, 209977, 209978, 209979, 209980, 209981, 209982, 209983, 209984, 209987, 209989, 209985, 209988, 209986, 210115, 210113, 210227, 210257, 210484, 210545, 210564, 210587, 210733, 210758, 210858])
    free_enrolment_ids = orders.map{|o| o.purchase_items.where("purchasable_type = 'Enrolment' AND purchasable_id NOT IN (#{free_trial_enrolment_ids.join(',')})").pluck(:purchasable_id) }.flatten.uniq

    Enrolment.includes(:user).where(id: free_enrolment_ids).find_each do |enrolment|
      transferred_ones = enrolment.user&.enrolments&.where(state: 'Transferred')&.where&.not(id: enrolment.id)
      enrolment.update(state: 'Transferred')

      transferred_ones&.update_all(state: 'Unenrolled')
    end
  end

  task update_previous_free_orders_to_paid: :environment do
    ActiveRecord::Base.transaction do
      free_trial_enrolment_ids = Course.includes(:enrolments)
                                       .where(id: ProductVersion.includes(:courses)
                                                                .where(price: 0)
                                                                .map{ |pv| pv.courses.ids.uniq }
                                                                .flatten.uniq)
                                       .map{ |c|  c.enrolments.ids.uniq }.flatten.uniq
      free_enrolment_orders = Order.free
                                   .includes(:purchase_items)
                                   .where("purchase_items.purchasable_type = 'Enrolment' AND purchase_items.purchasable_id NOT IN (#{free_trial_enrolment_ids.join(',')})")
                                   .references(:purchase_items)
      free_enrolment_orders.update_all(status: :paid)
      free_enrolment_ids = free_enrolment_orders.map{|o| o.purchase_items.where("purchasable_type = 'Enrolment' AND purchasable_id NOT IN (#{free_trial_enrolment_ids.join(',')})").pluck(:purchasable_id) }.uniq

      Enrolment.includes(:user).where(id: free_enrolment_ids).find_each do |enrolment|
        transferred_ones = enrolment.user&.enrolments&.where(state: 'Transferred')&.not(id: enrolment.id)
        enrolment.update(state: 'Transferred')

        transferred_ones&.update_all(state: 'Unenrolled')
      end

      Order.includes(:purchase_items)
           .where(id: PurchaseItem.includes(:order).where("orders.status = 3 AND purchasable_type = 'FeatureLog'")
           .pluck(:order_id).uniq.reject(&:blank?)).find_each do |o|
        if (o.purchase_items.where(purchasable_type: 'FeatureLog').map{ |p| p.purchasable.enrolment_id }.uniq & free_trial_enrolment_ids).blank?
          o.update(status: :paid)
        end
      end
    end
  end
end

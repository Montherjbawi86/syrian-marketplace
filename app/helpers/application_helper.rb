module ApplicationHelper
  # Category and Subcategory Helpers
  def subcategory_icon_class(subcategory)
    case subcategory.name.downcase
    when 'flat', 'flats', 'apartments', 'شقق'
      'fa-building'
    when 'house', 'houses', 'villas', 'فلل', 'بيوت'
      'fa-home'
    when 'land', 'lands', 'أراضي'
      'fa-tree'
    when 'office', 'offices', 'مكاتب'
      'fa-building'
    when 'shop', 'shops', 'محلات تجارية'
      'fa-store'
    when 'warehouse', 'warehouses', 'مستودعات'
      'fa-warehouse'
    when 'garage', 'garages', 'كراجات'
      'fa-parking'
    when 'cars', 'سيارات'
      'fa-car'
    when 'motorcycles', 'دراجات نارية'
      'fa-motorcycle'
    when 'trucks', 'شاحنات'
      'fa-truck'
    when 'buses', 'باصات'
      'fa-bus'
    when 'boats', 'قوارب'
      'fa-ship'
    when 'full time', 'دوام كامل'
      'fa-clock'
    when 'part time', 'دوام جزئي'
      'fa-hourglass-half'
    when 'remote', 'عن بعد'
      'fa-laptop'
    when 'freelance', 'عمل حر'
      'fa-user-friends'
    else
      'fa-folder'
    end
  end

  def category_icon(category)
    case category.name.downcase
    when 'real estate', 'عقارات'
      'fa-building'
    when 'vehicles', 'مركبات'
      'fa-car'
    when 'jobs', 'وظائف'
      'fa-briefcase'
    when 'electronics', 'الكترونيات'
      'fa-mobile-alt'
    when 'services', 'خدمات'
      'fa-handshake'
    when 'furniture', 'أثاث'
      'fa-couch'
    when 'clothing', 'ملابس'
      'fa-tshirt'
    when 'pets', 'حيوانات'
      'fa-paw'
    when 'books', 'كتب'
      'fa-book'
    when 'sports', 'رياضة'
      'fa-futbol'
    when 'beauty', 'تجميل'
      'fa-spa'
    when 'food', 'طعام'
      'fa-utensils'
    else
      'fa-tag'
    end
  end
def icon_for_listing_type(listing_type)
  case listing_type
  when 'sell' then 'fa-tag'
  when 'rent' then 'fa-home'
  when 'wanted' then 'fa-search'
  when 'job' then 'fa-briefcase'
  else 'fa-tag'
  end
end
  # Listing Type Helpers
  def listing_type_badge_class(listing_type)
    case listing_type
    when 'sell'
      'bg-success'
    when 'rent'
      'bg-info'
    when 'wanted'
      'bg-warning text-dark'
    when 'job'
      'bg-purple'
    else
      'bg-secondary'
    end
  end

  def listing_type_icon(listing_type)
    case listing_type
    when 'sell'
      'fa-tag'
    when 'rent'
      'fa-key'
    when 'wanted'
      'fa-clipboard-list'
    when 'job'
      'fa-briefcase'
    else
      'fa-ad'
    end
  end

  def listing_type_text(listing_type)
    case listing_type
    when 'sell'
      'للبيع'
    when 'rent'
      'للإيجار'
    when 'wanted'
      'مطلوب'
    when 'job'
      'وظيفة'
    else
      listing_type
    end
  end

  def listing_type_display(listing_type)
    case listing_type
    when 'sell'
      'للبيع'
    when 'rent'
      'للإيجار'
    when 'wanted'
      'مطلوب'
    when 'job'
      'وظيفة'
    else
      listing_type
    end
  end

  # Condition Helpers
  def condition_text(condition)
    case condition
    when 'brand_new'
      'جديد'
    when 'like_new'
      'مثل جديد'
    when 'good'
      'جيد'
    when 'fair'
      'مقبول'
    when 'poor'
      'ضعيف'
    else
      condition
    end
  end

  def condition_display(condition)
    case condition
    when 'brand_new'
      'جديد'
    when 'like_new'
      'مثل جديد'
    when 'good'
      'جيد'
    when 'fair'
      'مقبول'
    when 'poor'
      'ضعيف'
    else
      condition
    end
  end

  def listing_condition_badge_class(condition)
    case condition
    when 'brand_new', 'new'
      'bg-primary'
    when 'like_new', 'excellent'
      'bg-success'
    when 'good', 'very_good'
      'bg-info'
    when 'fair'
      'bg-secondary'
    when 'poor', 'used'
      'bg-warning text-dark'
    else
      'bg-light text-dark'
    end
  end

  # Price Formatting
  def format_price(price)
    return "غير محدد" if price.blank?
    number_to_currency(price, unit: "ل.س", format: "%u %n", precision: 0)
  end

  def formatted_price(price)
    return "السعر غير محدد" if price.blank? || price == 0
    number_to_currency(price, unit: "ل.س", format: "%u %n", precision: 0)
  end

  # Time Formatting
  def time_ago(time)
    return "منذ وقت طويل" if time.blank?
    time_ago_in_words(time) + " منذ"
  end

  # WhatsApp Helper
  def whatsapp_url(phone, message)
    return "#" if phone.blank?
    encoded_message = URI.encode_www_form_component(message)
    "https://wa.me/#{phone}?text=#{encoded_message}"
  end
end

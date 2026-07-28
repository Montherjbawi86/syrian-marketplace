# db/seeds.rb
puts "🌱 Starting to seed database..."
puts "=" * 60

# Clear existing data (optional - uncomment if you want to reset)
# puts "🗑️  Clearing existing data..."
# Category.destroy_all
# City.destroy_all
# User.destroy_all

# =============================================
# 1. CREATE CITIES
# =============================================
puts "\n📌 Creating cities..."

cities = [
  { name: "Damascus", name_ar: "دمشق" },
  { name: "Aleppo", name_ar: "حلب" },
  { name: "Homs", name_ar: "حمص" },
  { name: "Latakia", name_ar: "اللاذقية" },
  { name: "Hama", name_ar: "حماة" },
  { name: "Tartus", name_ar: "طرطوس" },
  { name: "Idlib", name_ar: "إدلب" },
  { name: "Daraa", name_ar: "درعا" },
  { name: "Deir ez-Zor", name_ar: "دير الزور" },
  { name: "Al-Hasakah", name_ar: "الحسكة" },
  { name: "Al-Raqqah", name_ar: "الرقة" },
  { name: "Quneitra", name_ar: "القنيطرة" },
  { name: "Al-Suwayda", name_ar: "السويداء" },
  { name: "Rif Dimashq", name_ar: "ريف دمشق" }
]

cities.each do |city|
  City.find_or_create_by!(name: city[:name]) do |c|
    c.name_ar = city[:name_ar]
    c.active = true
    print "."
  end
end
puts " ✅ #{City.count} cities created"

# =============================================
# 2. CREATE CATEGORIES & SUBCATEGORIES
# =============================================
puts "\n📌 Creating categories and subcategories..."

# Main categories with their subcategories
categories_data = [
  {
    name: "Real Estate",
    name_ar: "عقارات",
    icon: "fa-building",
    category_type: 1, # real_estate
    sort_order: 1,
    subcategories: [
      "شقق",
      "منازل",
      "أراضي",
      "فلل",
      "محلات تجارية",
      "مكاتب",
      "مستودعات",
      "مباني"
    ]
  },
  {
    name: "Vehicles",
    name_ar: "مركبات",
    icon: "fa-car",
    category_type: 2, # vehicles
    sort_order: 2,
    subcategories: [
      "سيارات",
      "دراجات نارية",
      "شاحنات",
      "باصات",
      "قوارب",
      "جرارات",
      "قطع غيار",
      "إطارات"
    ]
  },
  {
    name: "Jobs",
    name_ar: "وظائف",
    icon: "fa-briefcase",
    category_type: 3, # jobs
    sort_order: 3,
    subcategories: [
      { name: "تقنية المعلومات", name_ar: "تقنية المعلومات" },
      { name: "الهندسة", name_ar: "الهندسة" },
      { name: "الطب", name_ar: "الطب" },
      { name: "التعليم", name_ar: "التعليم" },
      { name: "المبيعات", name_ar: "المبيعات" },
      { name: "التسويق", name_ar: "التسويق" },
      { name: "المحاسبة", name_ar: "المحاسبة" },
      { name: "الإدارة", name_ar: "الإدارة" },
      { name: "دوام كامل", name_ar: "دوام كامل" },
      { name: "دوام جزئي", name_ar: "دوام جزئي" },
      { name: "عن بعد", name_ar: "عن بعد" },
      { name: "عمل حر", name_ar: "عمل حر" },
      { name: "تدريب", name_ar: "تدريب" }
    ]
  },
  {
    name: "Electronics",
    name_ar: "إلكترونيات",
    icon: "fa-mobile-alt",
    category_type: 5, # electronics
    sort_order: 4,
    subcategories: [
      "هواتف ذكية",
      "حواسيب",
      "أجهزة لوحية",
      "تلفزيونات",
      "كاميرات",
      "طابعات",
      "سماعات",
      "ألعاب فيديو",
      "شواحن",
      "قطع غيار"
    ]
  },
  {
    name: "Services",
    name_ar: "خدمات",
    icon: "fa-handshake",
    category_type: 4, # services
    sort_order: 5,
    subcategories: [
      "تنظيف",
      "صيانة",
      "كهرباء",
      "سباكة",
      "دهان",
      "بناء",
      "تدريس خصوصي",
      "نقل",
      "تصميم جرافيك",
      "برمجة",
      "ترجمة",
      "تصوير"
    ]
  },
  {
    name: "Furniture",
    name_ar: "أثاث",
    icon: "fa-couch",
    category_type: 14, # furniture
    sort_order: 6,
    subcategories: [
      "غرف نوم",
      "غرف معيشة",
      "طاولات طعام",
      "مكاتب منزلية",
      "مطابخ",
      "كراسي",
      "أرائك",
      "خزائن",
      "إكسسوارات"
    ]
  },
  {
    name: "Fashion",
    name_ar: "أزياء",
    icon: "fa-tshirt",
    category_type: 6, # fashion
    sort_order: 7,
    subcategories: [
      "رجالي",
      "نسائي",
      "أطفال",
      "أحذية",
      "حقائب",
      "ساعات",
      "نظارات",
      "مجوهرات",
      "عطور"
    ]
  },
  {
    name: "Pets",
    name_ar: "حيوانات",
    icon: "fa-paw",
    category_type: 8, # pets
    sort_order: 8,
    subcategories: [
      "كلاب",
      "قطط",
      "طيور",
      "أسماك",
      "قوارض",
      "مستلزمات",
      "أطعمة",
      "خدمات بيطرية"
    ]
  },
  {
    name: "Books",
    name_ar: "كتب",
    icon: "fa-book",
    category_type: 9, # books
    sort_order: 9,
    subcategories: [
      "روايات",
      "قصص قصيرة",
      "كتب تعليمية",
      "كتب دينية",
      "كتب أطفال",
      "تنمية بشرية",
      "تاريخ",
      "سياسة",
      "فلسفة",
      "علم نفس"
    ]
  },
  {
    name: "Sports",
    name_ar: "رياضة",
    icon: "fa-futbol",
    category_type: 10, # sports
    sort_order: 10,
    subcategories: [
      "لياقة بدنية",
      "كرة قدم",
      "كرة سلة",
      "كرة طائرة",
      "سباحة",
      "تنس",
      "جولف",
      "تخييم",
      "صيد",
      "معدات رياضية"
    ]
  },
  {
    name: "Home & Garden",
    name_ar: "منزل وحديقة",
    icon: "fa-leaf",
    category_type: 7, # home_garden
    sort_order: 11,
    subcategories: [
      "أدوات منزلية",
      "مطبخ",
      "حمام",
      "حدائق",
      "نباتات",
      "أدوات حديقة",
      "إضاءة",
      "ديكور"
    ]
  },
  {
    name: "Beauty",
    name_ar: "جمال",
    icon: "fa-spa",
    category_type: 11, # beauty
    sort_order: 12,
    subcategories: [
      "مكياج",
      "عناية بالبشرة",
      "عناية بالشعر",
      "عطور",
      "مستحضرات تجميل",
      "أدوات تجميل",
      "صالونات"
    ]
  },
  {
    name: "Education",
    name_ar: "تعليم",
    icon: "fa-graduation-cap",
    category_type: 12, # education
    sort_order: 13,
    subcategories: [
      "دورات تدريبية",
      "كتب مدرسية",
      "أدوات مدرسية",
      "تعليم عن بعد",
      "مراكز تعليمية",
      "لغات",
      "حاسوب",
      "فنون"
    ]
  },
  {
    name: "Food",
    name_ar: "طعام",
    icon: "fa-utensils",
    category_type: 13, # food
    sort_order: 14,
    subcategories: [
      "مطاعم",
      "مقاهي",
      "حلويات",
      "مخبوزات",
      "مواد غذائية",
      "مشروبات",
      "توصيل طلبات"
    ]
  }
]

# Create categories and subcategories
categories_data.each do |cat_data|
  # Create or find category
  category = Category.find_or_initialize_by(name: cat_data[:name])

  category.assign_attributes(
    name_ar: cat_data[:name_ar],
    icon: cat_data[:icon],
    category_type: cat_data[:category_type],
    active: true
  )

  if category.save
    puts "  ✅ Created category: #{category.name_ar}"
  else
    puts "  ⚠️  Category #{category.name_ar} already exists"
  end

  # Create subcategories
  cat_data[:subcategories].each do |subcat|
    # Handle both string and hash formats
    if subcat.is_a?(String)
      subcat_name = subcat
      subcat_name_ar = subcat
    else
      subcat_name = subcat[:name]
      subcat_name_ar = subcat[:name_ar]
    end

    subcategory = Subcategory.find_or_initialize_by(
      name: subcat_name,
      category_id: category.id
    )

    subcategory.assign_attributes(
      name_ar: subcat_name_ar,
      active: true
    )

    if subcategory.save
      print "."
    end
  end
  puts " ✅ Subcategories created"
end

# =============================================
# 3. CREATE USERS
# =============================================
puts "\n📌 Creating users..."

# Admin user
admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.assign_attributes(
  password: 'password123',
  password_confirmation: 'password123',
  username: 'مدير النظام',
  phone: '123456789',
  role: :admin,
  status: :active
)

if admin.save
  puts "  ✅ Admin user created: admin@example.com / password123"
end

# Regular user
user = User.find_or_initialize_by(email: 'user@example.com')
user.assign_attributes(
  password: 'password123',
  password_confirmation: 'password123',
  username: 'مستخدم تجريبي',
  phone: '987654321',
  role: :user,
  status: :active
)

if user.save
  puts "  ✅ Regular user created: user@example.com / password123"
end

# Company user (for job postings)
company = User.find_or_initialize_by(email: 'company@example.com')
company.assign_attributes(
  password: 'password123',
  password_confirmation: 'password123',
  username: 'شركة تجريبية',
  phone: '555555555',
  role: :user,
  status: :active,
  company: true,
  jobseeker: false
)

if company.save
  puts "  ✅ Company user created: company@example.com / password123"
end

# Job seeker user
jobseeker = User.find_or_initialize_by(email: 'jobseeker@example.com')
jobseeker.assign_attributes(
  password: 'password123',
  password_confirmation: 'password123',
  username: 'باحث عن عمل',
  phone: '444444444',
  role: :user,
  status: :active,
  company: false,
  jobseeker: true,
  bio: "أبحث عن فرصة عمل في مجال تكنولوجيا المعلومات"
)

if jobseeker.save
  puts "  ✅ Job seeker user created: jobseeker@example.com / password123"
end

# =============================================
# 4. SAMPLE LISTINGS (Optional)
# =============================================
puts "\n📌 Creating sample listings (optional)..."

if Listing.count == 0
  # Get references
  real_estate = Category.find_by(name: "Real Estate")
  vehicles = Category.find_by(name: "Vehicles")
  electronics = Category.find_by(name: "Electronics")
  damascus = City.find_by(name: "Damascus")
  aleppo = City.find_by(name: "Aleppo")
  regular_user = User.find_by(email: 'user@example.com')

  if real_estate && damascus && regular_user
    # Sample apartment listing
    Listing.find_or_create_by!(
      title_ar: "شقة فاخرة للبيع في دمشق",
      description_ar: "شقة فاخرة بمساحة 150 متر مربع، 3 غرف نوم، صالون، مطبخ حديث، حمامان، إطلالة رائعة",
      price: 250000000,
      listing_type: :sell,
      condition: :like_new,
      status: :active,
      user: regular_user,
      city: damascus,
      category: real_estate
    )
    puts "  ✅ Sample real estate listing created"

    # Sample car listing
    Listing.find_or_create_by!(
      title_ar: "تويوتا كورولا 2020 للبيع",
      description_ar: "سيارة بحالة ممتازة، قليلة الاستخدام، صيانة وكالة، لون أبيض",
      price: 25000000,
      listing_type: :sell,
      condition: :good,
      status: :active,
      user: regular_user,
      city: damascus,
      category: vehicles
    )
    puts "  ✅ Sample vehicle listing created"

    # Sample electronics listing
    Listing.find_or_create_by!(
      title_ar: "آيفون 14 برو ماكس للبيع",
      description_ar: "هاتف بحالة ممتازة، كامل الملحقات، ضمان لمدة سنة",
      price: 1200000,
      listing_type: :sell,
      condition: :brand_new,
      status: :active,
      user: regular_user,
      city: aleppo,
      category: electronics
    )
    puts "  ✅ Sample electronics listing created"
  end
else
  puts "  ⚠️ Listings already exist, skipping sample creation..."
end

# =============================================
# 5. FINAL SUMMARY
# =============================================
puts "\n" + "=" * 60
puts "🌱 SEEDING COMPLETE!"
puts "=" * 60
puts "📊 Summary:"
puts "   🏙️  Cities: #{City.count}"
puts "   📂 Categories: #{Category.count}"
puts "   📁 Subcategories: #{Subcategory.count}"
puts "   👤 Users: #{User.count}"
puts "   📄 Listings: #{Listing.count}"
puts "=" * 60
puts "\n🔐 Login Credentials:"
puts "   👑 Admin:    admin@example.com / password123"
puts "   👤 User:     user@example.com / password123"
puts "   🏢 Company:  company@example.com / password123"
puts "   🔍 Job Seeker: jobseeker@example.com / password123"
puts "=" * 60

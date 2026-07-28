# db/seeds_sample_listings.rb
# Run: heroku run rails runner db/seeds_sample_listings.rb

puts "🌱 Creating 30+ sample listings with local images..."
puts "=" * 60

# Get or create demo user
demo_user = User.find_or_create_by!(email: "demo@sample.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.username = "demo_user"
  u.phone = "0999999999"
  u.role = :user
  u.status = :active
end
puts "✅ Demo user ready: #{demo_user.email}"

# Get cities
cities = City.all
if cities.empty?
  cities = [
    City.create!(name: "Damascus", name_ar: "دمشق", active: true),
    City.create!(name: "Aleppo", name_ar: "حلب", active: true),
    City.create!(name: "Homs", name_ar: "حمص", active: true),
    City.create!(name: "Latakia", name_ar: "اللاذقية", active: true)
  ]
end

# Helper method to attach local image
def attach_local_image(listing, category_name)
  # Map category to image path
  image_paths = {
    'Real Estate' => [
      Rails.root.join('app/assets/images/listings/real_estate/apartment1.jpg'),
      Rails.root.join('app/assets/images/listings/real_estate/apartment2.jpg'),
      Rails.root.join('app/assets/images/listings/real_estate/villa1.jpg'),
      Rails.root.join('app/assets/images/listings/real_estate/land1.jpg')
    ],
    'Vehicles' => [
      Rails.root.join('app/assets/images/listings/vehicles/car1.jpg'),
      Rails.root.join('app/assets/images/listings/vehicles/car2.jpg'),
      Rails.root.join('app/assets/images/listings/vehicles/motorcycle1.jpg')
    ],
    'Electronics' => [
      Rails.root.join('app/assets/images/listings/electronics/phone1.jpg'),
      Rails.root.join('app/assets/images/listings/electronics/laptop1.jpg'),
      Rails.root.join('app/assets/images/listings/electronics/tablet1.jpg')
    ],
    'Furniture' => [
      Rails.root.join('app/assets/images/listings/furniture/bedroom1.jpg'),
      Rails.root.join('app/assets/images/listings/furniture/living1.jpg'),
      Rails.root.join('app/assets/images/listings/furniture/dining1.jpg')
    ],
    'Fashion' => [
      Rails.root.join('app/assets/images/listings/fashion/men1.jpg'),
      Rails.root.join('app/assets/images/listings/fashion/women1.jpg'),
      Rails.root.join('app/assets/images/listings/fashion/shoes1.jpg')
    ],
    'Jobs' => [
      Rails.root.join('app/assets/images/listings/jobs/job1.jpg'),
      Rails.root.join('app/assets/images/listings/jobs/job2.jpg')
    ]
  }
  
  # Get images for this category or use default
  images = image_paths[category_name] || [Rails.root.join('app/assets/images/listings/default.jpg')]
  image_path = images.sample
  
  # Check if image exists
  if File.exist?(image_path)
    listing.images.attach(io: File.open(image_path), filename: File.basename(image_path), content_type: 'image/jpeg')
    puts "      📸 Image attached from local file"
    return true
  else
    puts "      ⚠️ Image not found: #{image_path}"
    return false
  end
end

# Sample listings data
listings_data = [
  # Real Estate
  { subcategory: "شقق", title: "شقة فاخرة للبيع في دمشق", price: 250000000, type: "sell", condition: "brand_new", city: "دمشق", desc: "شقة فاخرة بمساحة 180م، 3 غرف نوم" },
  { subcategory: "شقق", title: "شقة مفروشة للإيجار في اللاذقية", price: 5000000, type: "rent", condition: "like_new", city: "اللاذقية", desc: "شقة مفروشة بالكامل" },
  { subcategory: "فلل", title: "فيلا فاخرة للبيع مع مسبح", price: 750000000, type: "sell", condition: "brand_new", city: "دمشق", desc: "فيلا راقية بمساحة 500م" },
  { subcategory: "أراضي", title: "أرض سكنية للبيع في دمشق", price: 200000000, type: "sell", condition: "good", city: "دمشق", desc: "قطعة أرض بمساحة 600م" },
  
  # Vehicles
  { subcategory: "سيارات", title: "تويوتا كورولا 2023 للبيع", price: 25000000, type: "sell", condition: "like_new", city: "دمشق", desc: "سيارة بحالة ممتازة" },
  { subcategory: "سيارات", title: "مرسيدس E300 2021", price: 85000000, type: "sell", condition: "like_new", city: "دمشق", desc: "مرسيدس فاخرة" },
  { subcategory: "دراجات نارية", title: "هوندا CBR 600 للبيع", price: 45000000, type: "sell", condition: "like_new", city: "دمشق", desc: "دراجة رياضية قوية" },
  
  # Electronics
  { subcategory: "هواتف ذكية", title: "آيفون 15 برو ماكس", price: 1800000, type: "sell", condition: "brand_new", city: "دمشق", desc: "أحدث إصدار" },
  { subcategory: "هواتف ذكية", title: "سامسونج جالاكسي S24", price: 1500000, type: "sell", condition: "brand_new", city: "اللاذقية", desc: "هاتف جديد" },
  { subcategory: "حواسيب", title: "ماك بوك برو M3", price: 3500000, type: "sell", condition: "brand_new", city: "دمشق", desc: "لابتوب احترافي" },
  
  # Jobs
  { subcategory: "تقنية المعلومات", title: "مبرمج ويب - دوام كامل", price: 0, type: "job", condition: "brand_new", city: "دمشق", desc: "مطلوب مبرمج ويب" },
  { subcategory: "الهندسة", title: "مهندس معماري", price: 0, type: "job", condition: "brand_new", city: "حلب", desc: "مطلوب مهندس معماري" },
  
  # Furniture
  { subcategory: "غرف نوم", title: "غرفة نوم كاملة للبيع", price: 3500000, type: "sell", condition: "like_new", city: "دمشق", desc: "غرفة نوم مودرن" },
  { subcategory: "غرف معيشة", title: "صالون كلاسيك للبيع", price: 4500000, type: "sell", condition: "good", city: "حلب", desc: "صالون فاخر" },
  
  # Fashion
  { subcategory: "رجالي", title: "بدلة رجالي ماركة عالمية", price: 800000, type: "sell", condition: "like_new", city: "دمشق", desc: "بدلة فاخرة" },
  { subcategory: "نسائي", title: "فستان سهرة جديد", price: 350000, type: "sell", condition: "brand_new", city: "اللاذقية", desc: "فستان طويل" }
]

puts "\n📌 Creating sample listings..."

success_count = 0
listings_data.each_with_index do |data, index|
  subcategory = Subcategory.find_by(name_ar: data[:subcategory])
  next unless subcategory
  
  city = City.find_by(name_ar: data[:city])
  next unless city
  
  existing = Listing.find_by(title_ar: data[:title])
  if existing
    puts "  ⏩ #{index + 1}. Already exists: #{data[:title]}"
    next
  end
  
  listing = Listing.new(
    title: data[:title],
    title_ar: data[:title],
    description: data[:desc],
    description_ar: data[:desc],
    price: data[:price],
    listing_type: data[:type],
    condition: data[:condition],
    status: :active,
    user: demo_user,
    category: subcategory.category,
    subcategory: subcategory,
    city: city
  )
  
  if listing.save
    success_count += 1
    puts "  ✅ #{index + 1}. Created: #{data[:title]}"
    attach_local_image(listing, subcategory.category.name)
  else
    puts "  ❌ Error: #{listing.errors.full_messages.join(', ')}"
  end
end

puts "\n" + "=" * 60
puts "🌱 Sample listings created successfully!"
puts "=" * 60
puts "📊 Total Listings: #{Listing.count}"
puts "📊 New Listings Created: #{success_count}"
puts "=" * 60

# 既存のデータをクリア（開発環境のみ）
if Rails.env.development?
  FlowerSpot.destroy_all
  Flower.destroy_all
  Mountain.destroy_all
  Region.destroy_all
end

puts "シードデータを作成中..."

# 地域データ
regions_data = [
  { name: '北海道', code: 'HOKKAIDO' },
  { name: '東北', code: 'TOHOKU' },
  { name: '関東', code: 'KANTO' },
  { name: '中部', code: 'CHUBU' },
  { name: '近畿', code: 'KINKI' },
  { name: '中国', code: 'CHUGOKU' },
  { name: '四国', code: 'SHIKOKU' },
  { name: '九州', code: 'KYUSHU' }
]

regions = regions_data.map do |region_data|
  Region.create!(region_data)
end

puts "地域データを#{regions.count}件作成しました"

# 山データ
chubu_region = Region.find_by(code: 'CHUBU')
tohoku_region = Region.find_by(code: 'TOHOKU')
kanto_region = Region.find_by(code: 'KANTO')

mountains_data = [
  {
    name: '八ヶ岳（赤岳）',
    elevation: 2899,
    latitude: 35.9708,
    longitude: 138.3714,
    region: chubu_region,
    prefecture: '長野県',
    description: '八ヶ岳連峰の最高峰。高山植物の宝庫として知られる。'
  },
  {
    name: '白山（御前峰）',
    elevation: 2702,
    latitude: 36.1565,
    longitude: 136.7729,
    region: chubu_region,
    prefecture: '石川県',
    description: '日本三名山の一つ。ハクサンイチゲなど固有の高山植物が豊富。'
  },
  {
    name: '立山（雄山）',
    elevation: 3003,
    latitude: 36.5742,
    longitude: 137.6194,
    region: chubu_region,
    prefecture: '富山県',
    description: '立山連峰の主峰。室堂周辺は高山植物の名所。'
  },
  {
    name: '尾瀬ヶ原',
    elevation: 1400,
    latitude: 36.8833,
    longitude: 139.2833,
    region: kanto_region,
    prefecture: '群馬県',
    description: '日本最大の高層湿原。ミズバショウの群生地として有名。'
  }
]

mountains = mountains_data.map do |mountain_data|
  Mountain.create!(mountain_data)
end

puts "山データを#{mountains.count}件作成しました"

# 花データ
flowers_data = [
  {
    name: 'コマクサ',
    scientific_name: 'Dicentra peregrina',
    description: '高山植物の女王と呼ばれる美しい花。砂礫地に咲く。',
    color: 'ピンク',
    size: '小',
    habitat: '砂礫地',
    bloom_start_month: 6,
    bloom_end_month: 8,
    peak_month: 7,
    altitude_min: 2500,
    altitude_max: 3500,
    difficulty_level: 'intermediate',
    image_url: '/placeholder.svg?height=200&width=300'
  },
  {
    name: 'ハクサンイチゲ',
    scientific_name: 'Anemone narcissiflora var. nipponica',
    description: '白山で最初に発見された高山植物。白い花が美しい。',
    color: '白',
    size: '中',
    habitat: '草原',
    bloom_start_month: 7,
    bloom_end_month: 8,
    peak_month: 7,
    altitude_min: 1500,
    altitude_max: 3000,
    difficulty_level: 'beginner',
    image_url: '/placeholder.svg?height=200&width=300'
  },
  {
    name: 'チングルマ',
    scientific_name: 'Geum pentapetalum',
    description: '高山帯の代表的な花。白い花と綿毛の果実が特徴。',
    color: '白',
    size: '小',
    habitat: '湿原・草原',
    bloom_start_month: 6,
    bloom_end_month: 7,
    peak_month: 6,
    altitude_min: 1800,
    altitude_max: 3000,
    difficulty_level: 'intermediate',
    image_url: '/placeholder.svg?height=200&width=300'
  },
  {
    name: 'ミズバショウ',
    scientific_name: 'Lysichiton camtschatcensis',
    description: '湿原に咲く代表的な花。白い苞が美しい。',
    color: '白',
    size: '大',
    habitat: '湿原',
    bloom_start_month: 4,
    bloom_end_month: 6,
    peak_month: 5,
    altitude_min: 500,
    altitude_max: 2000,
    difficulty_level: 'beginner',
    image_url: '/placeholder.svg?height=200&width=300'
  }
]

flowers = flowers_data.map do |flower_data|
  Flower.create!(flower_data)
end

puts "花データを#{flowers.count}件作成しました"

# 花スポットデータ（花と山の関連付け）
flower_spots_data = [
  {
    flower: Flower.find_by(name: 'コマクサ'),
    mountain: Mountain.find_by(name: '八ヶ岳（赤岳）'),
    best_viewing_time: '7月中旬〜下旬',
    notes: '赤岳山頂付近の砂礫地で見ることができます。'
  },
  {
    flower: Flower.find_by(name: 'ハクサンイチゲ'),
    mountain: Mountain.find_by(name: '白山（御前峰）'),
    best_viewing_time: '7月下旬〜8月上旬',
    notes: '室堂周辺の草原に群生します。'
  },
  {
    flower: Flower.find_by(name: 'チングルマ'),
    mountain: Mountain.find_by(name: '立山（雄山）'),
    best_viewing_time: '6月下旬〜7月上旬',
    notes: '室堂平の湿原で見ることができます。'
  },
  {
    flower: Flower.find_by(name: 'ミズバショウ'),
    mountain: Mountain.find_by(name: '尾瀬ヶ原'),
    best_viewing_time: '5月中旬〜下旬',
    notes: '尾瀬ヶ原の湿原一面に咲きます。'
  }
]

flower_spots = flower_spots_data.map do |spot_data|
  FlowerSpot.create!(spot_data)
end

puts "花スポットデータを#{flower_spots.count}件作成しました"
puts "シードデータの作成が完了しました！"


puts "開花報告のテストデータを作成中..."

# テストユーザーを作成（まだない場合）
test_users = []
3.times do |i|
  user = User.find_or_create_by(email: "user#{i+1}@example.com") do |u|
    u.password = "password123"
    u.password_confirmation = "password123"
    u.last_name = "テスト"
    u.first_name = "ユーザー#{i+1}"
    u.last_name_kana = "テスト"
    u.first_name_kana = "ユーザー#{i+1}"
    u.nickname = "testuser#{i+1}"
    u.birth_date = 30.years.ago
  end
  test_users << user
end

# 開花報告データ
bloom_reports_data = [
  {
    user: test_users[0],
    flower_spot: FlowerSpot.first,
    title: "コマクサが見頃です！",
    description: "八ヶ岳のコマクサが満開でした。天気も良く、最高の登山日和でした。",
    bloom_status: :peak,
    status: :approved,
    reported_at: 2.days.ago
  },
  {
    user: test_users[1],
    flower_spot: FlowerSpot.second,
    title: "ハクサンイチゲ咲き始め",
    description: "白山でハクサンイチゲが咲き始めています。来週が見頃かもしれません。",
    bloom_status: :starting,
    status: :approved,
    reported_at: 1.day.ago
  },
  {
    user: test_users[2],
    flower_spot: FlowerSpot.third,
    title: "チングルマの群生地発見！",
    description: "立山でチングルマの素晴らしい群生地を見つけました。一面真っ白で感動的でした。",
    bloom_status: :peak,
    status: :approved,
    reported_at: 3.hours.ago
  }
]

bloom_reports = bloom_reports_data.map.with_index do |report_data, i|
  # 写真なしでBloomReportを作成（バリデーションを一時的に無効化）
  report = BloomReport.new(report_data)
  
  ## 画像添付（先に行う）
  report.photos.attach(
    io: File.open(Rails.root.join("db", "seed_images", "sample#{i+1}.jpg")),
    filename: "sample#{i+1}.jpg",
    content_type: "image/jpeg"
  )

  # バリデーション含めて保存
  report.save!

  report
end

puts "開花報告データを#{bloom_reports.count}件作成しました"

# いいねデータ
puts "いいねデータを作成中..."

bloom_reports.each do |report|
  # ランダムにいいねを付ける
  test_users.sample(rand(1..3)).each do |user|
    Like.find_or_create_by(user: user, bloom_report: report)
  end
end

puts "シードデータの作成が完了しました！"

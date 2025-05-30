import { Header } from '@/components/layout/Header'

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-green-50 to-blue-50">
      <Header />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">見頃の花を見逃さない</h1>
          <p className="text-xl text-gray-600 mb-8">
            あなたの行きたいエリアの高山植物の開花時期を事前にお知らせ。
            <br />
            忙しい日常でも、最高のタイミングで山の花に出会えます。
          </p>
          
          <div className="mt-8">
            <a 
              href="/reports" 
              className="inline-flex items-center justify-center px-6 py-3 border border-transparent text-base font-medium rounded-md text-white bg-green-600 hover:bg-green-700"
            >
              開花報告を見る
            </a>
          </div>
        </div>
        
        {/* ここに追加のコンテンツを実装 */}
      </main>
      
      <footer className="bg-gray-900 text-white py-8">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <p>© 2024 花山リマインダー. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
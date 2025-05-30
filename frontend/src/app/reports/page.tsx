"use client"

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { railsApi, BloomReport } from '@/lib/railsApi'
import { Header } from '@/components/layout/Header'
import { ReportCard } from '@/components/features/reports/ReportCard'
import { ReportFilters } from '@/components/features/reports/ReportFilters'
import { Button } from '@/components/ui/Button'
import { Plus, Loader2 } from 'lucide-react'
import { useAuth } from '@/hooks/useAuth'

export default function ReportsPage() {
  const [reports, setReports] = useState<BloomReport[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const [totalPages, setTotalPages] = useState(1)
  const [filters, setFilters] = useState({
    sort: 'recent',
    bloom_status: ''
  })
  
  const { isAuthenticated } = useAuth()
  const router = useRouter()

  useEffect(() => {
    fetchReports()
  }, [currentPage, filters])

  const fetchReports = async () => {
    setLoading(true)
    setError('')

    try {
      const params: any = {
        page: currentPage,
        sort: filters.sort
      }

      if (filters.bloom_status) {
        params.bloom_status = filters.bloom_status
      }

      const response = await railsApi.getBloomReports(params)

      if (response.data) {
        setReports(response.data.bloom_reports)
        setTotalPages(response.data.pagination.total_pages)
      } else {
        setError(response.error || '開花報告の取得に失敗しました')
      }
    } catch (err) {
      setError('開花報告の取得中にエラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  const handleFilterChange = (newFilters: any) => {
    setFilters(newFilters)
    setCurrentPage(1)
  }

  const handleCreateReport = () => {
    if (isAuthenticated) {
      router.push('/reports/new')
    } else {
      router.push('/auth')
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-green-50 to-blue-50">
      <Header />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-3xl font-bold text-gray-900">開花報告</h1>
          
          <Button onClick={handleCreateReport}>
            <Plus className="h-4 w-4 mr-2" />
            投稿する
          </Button>
        </div>
        
        <ReportFilters onFilterChange={handleFilterChange} />
        
        {loading && (
          <div className="flex justify-center items-center py-12">
            <Loader2 className="h-8 w-8 animate-spin text-green-600" />
          </div>
        )}
        
        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 p-4 rounded-md mb-6">
            {error}
          </div>
        )}
        
        {!loading && reports.length === 0 && (
          <div className="bg-white border rounded-lg p-12 text-center">
            <p className="text-gray-500 mb-4">開花報告がありません</p>
            <Button onClick={handleCreateReport}>
              最初の開花報告を投稿する
            </Button>
          </div>
        )}
        
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {reports.map((report) => (
            <ReportCard key={report.id} report={report} />
          ))}
        </div>
        
        {totalPages > 1 && (
          <div className="flex justify-center mt-8 space-x-2">
            <Button
              variant="outline"
              disabled={currentPage === 1}
              onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
            >
              前へ
            </Button>
            
            <span className="px-4 py-2 bg-white border rounded-md">
              {currentPage} / {totalPages}
            </span>
            
            <Button
              variant="outline"
              disabled={currentPage === totalPages}
              onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
            >
              次へ
            </Button>
          </div>
        )}
      </main>
    </div>
  )
}
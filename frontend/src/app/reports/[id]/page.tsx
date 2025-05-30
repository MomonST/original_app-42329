"use client"

import { useState, useEffect } from 'react'
import { useParams } from 'next/navigation'
import { railsApi, BloomReport } from '@/lib/railsApi'
import { Header } from '@/components/layout/Header'
import { LikeButton } from '@/components/features/reports/LikeButton'
import { Badge } from '@/components/ui/Badge'
import { Card, CardContent } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'
import { Eye, Calendar, MapPin, User, ArrowLeft } from 'lucide-react'
import { formatDate } from '@/utils/utils'
import Link from 'next/link'

export default function ReportDetailPage() {
  const { id } = useParams()
  const [report, setReport] = useState<BloomReport | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [activePhotoIndex, setActivePhotoIndex] = useState(0)

  useEffect(() => {
    if (id) {
      fetchReport(Number(id))
    }
  }, [id])

  const fetchReport = async (reportId: number) => {
    setLoading(true)
    setError('')

    try {
      const response = await railsApi.getBloomReport(reportId)

      if (response.data) {
        setReport(response.data)
      } else {
        setError(response.error || '開花報告の取得に失敗しました')
      }
    } catch (err) {
      setError('開花報告の取得中にエラーが発生しました')
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-green-50 to-blue-50">
        <Header />
        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="flex justify-center items-center py-12">
            <div className="animate-pulse">
              <div className="h-8 bg-gray-200 rounded w-64 mb-6"></div>
              <div className="h-64 bg-gray-200 rounded w-full mb-6"></div>
              <div className="h-4 bg-gray-200 rounded w-full mb-2"></div>
              <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
              <div className="h-4 bg-gray-200 rounded w-1/2"></div>
            </div>
          </div>
        </main>
      </div>
    )
  }

  if (error || !report) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-green-50 to-blue-50">
        <Header />
        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="bg-red-50 border border-red-200 text-red-700 p-4 rounded-md">
            {error || '開花報告が見つかりませんでした'}
          </div>
          <div className="mt-6">
            <Link href="/reports">
              <Button variant="outline">
                <ArrowLeft className="h-4 w-4 mr-2" />
                一覧に戻る
              </Button>
            </Link>
          </div>
        </main>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-green-50 to-blue-50">
      <Header />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-6">
          <Link href="/reports">
            <Button variant="outline" size="sm">
              <ArrowLeft className="h-4 w-4 mr-2" />
              一覧に戻る
            </Button>
          </Link>
        </div>
        
        <div className="bg-white rounded-lg shadow-sm border overflow-hidden">
          <div className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h1 className="text-3xl font-bold text-gray-900">{report.title}</h1>
              
              <Badge 
                variant={
                  report.bloom_status === 'peak' ? 'default' :
                  report.bloom_status === 'starting' ? 'secondary' :
                  'outline'
                }
                className="text-sm"
              >
                {report.bloom_status_ja}
              </Badge>
            </div>
            
            <div className="flex flex-wrap gap-4 text-sm text-gray-500 mb-6">
              <div className="flex items-center">
                <User className="h-4 w-4 mr-1" />
                {report.user.nickname}
              </div>
              <div className="flex items-center">
                <Calendar className="h-4 w-4 mr-1" />
                {formatDate(report.reported_at)}
              </div>
              <div className="flex items-center">
                <MapPin className="h-4 w-4 mr-1" />
                {report.location_name}
              </div>
              <div className="flex items-center">
                <Eye className="h-4 w-4 mr-1" />
                {report.view_count}回閲覧
              </div>
            </div>
            
            {report.photos && report.photos.length > 0 && (
              <div className="mb-6">
                <div className="aspect-video bg-gray-100 rounded-lg overflow-hidden mb-2">
                  <img
                    src={report.photos[activePhotoIndex].url || "/placeholder.svg"}
                    alt={`${report.title} - 写真 ${activePhotoIndex + 1}`}
                    className="w-full h-full object-contain"
                  />
                </div>
                
                {report.photos.length > 1 && (
                  <div className="flex gap-2 overflow-x-auto pb-2">
                    {report.photos.map((photo, index) => (
                      <button
                        key={photo.id}
                        onClick={() => setActivePhotoIndex(index)}
                        className={`w-20 h-20 rounded-md overflow-hidden border-2 ${
                          index === activePhotoIndex ? 'border-green-500' : 'border-transparent'
                        }`}
                      >
                        <img
                          src={photo.thumbnail_url || "/placeholder.svg"}
                          alt={`サムネイル ${index + 1}`}
                          className="w-full h-full object-cover"
                        />
                      </button>
                    ))}
                  </div>
                )}
              </div>
            )}
            
            <Card className="mb-6">
              <CardContent className="p-4">
                <h3 className="font-semibold mb-2">花の情報</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-gray-500">花名</p>
                    <p className="font-medium">{report.flower_name}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">場所</p>
                    <p className="font-medium">{report.location_name}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
            
            <div className="prose max-w-none mb-6">
              <h3 className="text-xl font-semibold mb-2">開花レポート</h3>
              <p className="whitespace-pre-line">{report.description || '説明はありません'}</p>
            </div>
            
            <div className="flex justify-between items-center">
              <LikeButton
                reportId={report.id}
                initialLikesCount={report.likes_count}
                initialIsLiked={report.is_liked || false}
              />
              
              <div className="text-sm text-gray-500">
                投稿ID: {report.id}
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}
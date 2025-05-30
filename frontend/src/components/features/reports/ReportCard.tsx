import Link from 'next/link'
import { BloomReport } from '@/lib/railsApi'
import { Card, CardContent } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Heart, Eye, MapPin } from 'lucide-react'
import { formatRelativeTime } from '@/utils/utils'

interface ReportCardProps {
  report: BloomReport
}

export function ReportCard({ report }: ReportCardProps) {
  return (
    <Link href={`/reports/${report.id}`}>
      <Card className="h-full overflow-hidden hover:shadow-md transition-shadow">
        <div className="aspect-video relative bg-gray-100">
          {report.photos && report.photos[0] ? (
            <img
              src={report.photos[0].thumbnail_url || "/placeholder.svg"}
              alt={report.title}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-400">
              画像なし
            </div>
          )}
          <Badge 
            className="absolute top-2 right-2"
            variant={
              report.bloom_status === 'peak' ? 'default' :
              report.bloom_status === 'starting' ? 'secondary' :
              'outline'
            }
          >
            {report.bloom_status_ja}
          </Badge>
        </div>
        <CardContent className="p-4">
          <h3 className="font-semibold text-lg mb-1 line-clamp-1">{report.title}</h3>
          <div className="flex items-center text-sm text-gray-500 mb-2">
            <MapPin className="h-3 w-3 mr-1" />
            <span className="line-clamp-1">{report.location_name}</span>
          </div>
          <div className="flex items-center text-sm text-gray-500 mb-2">
            <span className="font-medium text-green-600">{report.flower_name}</span>
          </div>
          <div className="flex items-center justify-between text-sm text-gray-500">
            <div className="flex items-center space-x-3">
              <span className="flex items-center">
                <Heart className="h-3 w-3 mr-1" />
                {report.likes_count}
              </span>
              <span className="flex items-center">
                <Eye className="h-3 w-3 mr-1" />
                {report.view_count}
              </span>
            </div>
            <span>{formatRelativeTime(report.reported_at)}</span>
          </div>
        </CardContent>
      </Card>
    </Link>
  )
}
"use client"

import { useState } from 'react'
import { Button } from '@/components/ui/Button'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/Select'
import { Filter } from 'lucide-react'

interface ReportFiltersProps {
  onFilterChange: (filters: {
    sort: string;
    bloom_status?: string;
  }) => void;
}

export function ReportFilters({ onFilterChange }: ReportFiltersProps) {
  const [sort, setSort] = useState<string>('recent')
  const [bloomStatus, setBloomStatus] = useState<string>('')

  const handleSortChange = (value: string) => {
    setSort(value)
    onFilterChange({
      sort: value,
      bloom_status: bloomStatus
    })
  }

  const handleBloomStatusChange = (value: string) => {
    setBloomStatus(value)
    onFilterChange({
      sort,
      bloom_status: value
    })
  }

  return (
    <div className="bg-white p-4 rounded-lg shadow-sm border mb-6">
      <div className="flex items-center justify-between flex-wrap gap-4">
        <div className="flex items-center">
          <Filter className="h-4 w-4 mr-2 text-gray-500" />
          <span className="text-sm font-medium">フィルター</span>
        </div>
        
        <div className="flex flex-wrap gap-4">
          <div className="w-40">
            <Select value={sort} onValueChange={handleSortChange}>
              <SelectTrigger>
                <SelectValue placeholder="並び順" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="recent">新着順</SelectItem>
                <SelectItem value="popular">人気順</SelectItem>
                <SelectItem value="most_viewed">閲覧数順</SelectItem>
              </SelectContent>
            </Select>
          </div>
          
          <div className="w-40">
            <Select value={bloomStatus} onValueChange={handleBloomStatusChange}>
              <SelectTrigger>
                <SelectValue placeholder="開花状況" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">すべて</SelectItem>
                <SelectItem value="bud">つぼみ</SelectItem>
                <SelectItem value="starting">咲き始め</SelectItem>
                <SelectItem value="peak">見頃</SelectItem>
                <SelectItem value="ending">散り始め</SelectItem>
                <SelectItem value="finished">終了</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
      </div>
    </div>
  )
}
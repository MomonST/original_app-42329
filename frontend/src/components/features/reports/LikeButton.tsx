"use client"

import { useState } from 'react'
import { railsApi } from '@/lib/railsApi'
import { Button } from '@/components/ui/Button'
import { Heart } from 'lucide-react'
import { useAuth } from '@/hooks/useAuth'
import { useRouter } from 'next/navigation'

interface LikeButtonProps {
  reportId: number
  initialLikesCount: number
  initialIsLiked: boolean
}

export function LikeButton({ reportId, initialLikesCount, initialIsLiked }: LikeButtonProps) {
  const [likesCount, setLikesCount] = useState(initialLikesCount)
  const [isLiked, setIsLiked] = useState(initialIsLiked)
  const [loading, setLoading] = useState(false)
  
  const { isAuthenticated } = useAuth()
  const router = useRouter()

  const handleLikeClick = async () => {
    if (!isAuthenticated) {
      router.push('/auth')
      return
    }

    setLoading(true)

    try {
      if (isLiked) {
        const response = await railsApi.unlikeBloomReport(reportId)
        if (response.data) {
          setLikesCount(response.data.likes_count)
          setIsLiked(false)
        }
      } else {
        const response = await railsApi.likeBloomReport(reportId)
        if (response.data) {
          setLikesCount(response.data.likes_count)
          setIsLiked(true)
        }
      }
    } catch (error) {
      console.error('いいね処理中にエラーが発生しました', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <Button
      variant={isLiked ? "default" : "outline"}
      size="sm"
      onClick={handleLikeClick}
      disabled={loading}
      className={isLiked ? "bg-pink-600 hover:bg-pink-700" : ""}
    >
      <Heart className={`h-4 w-4 mr-1 ${isLiked ? "fill-white" : ""}`} />
      {likesCount}
    </Button>
  )
}
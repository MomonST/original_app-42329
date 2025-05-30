"use client"

import Link from 'next/link'
import { useAuth } from '@/hooks/useAuth'
import { Button } from '@/components/ui/Button'
import { Mountain, LogIn, UserPlus, Settings, LogOut } from 'lucide-react'

export function Header() {
  const { user, isAuthenticated, logout } = useAuth()

  return (
    <header className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div className="flex items-center justify-between">
          <Link href="/" className="flex items-center space-x-2">
            <Mountain className="h-8 w-8 text-green-600" />
            <h1 className="text-2xl font-bold text-gray-900">花山リマインダー</h1>
          </Link>

          <nav className="hidden md:flex items-center space-x-6">
            <Link href="/" className="text-gray-600 hover:text-gray-900">
              ホーム
            </Link>
            <Link href="/reports" className="text-gray-600 hover:text-gray-900">
              開花報告
            </Link>
            <Link href="/rankings" className="text-gray-600 hover:text-gray-900">
              ランキング
            </Link>
            {isAuthenticated && (
              <Link href="/reports/new" className="text-gray-600 hover:text-gray-900">
                投稿する
              </Link>
            )}
          </nav>

          <div className="flex items-center space-x-3">
            {isAuthenticated ? (
              <>
                <span className="text-sm text-gray-600">
                  こんにちは、{user?.nickname}さん
                </span>
                <Button variant="outline" size="sm">
                  <Settings className="h-4 w-4 mr-2" />
                  設定
                </Button>
                <Button variant="ghost" size="sm" onClick={logout}>
                  <LogOut className="h-4 w-4 mr-2" />
                  ログアウト
                </Button>
              </>
            ) : (
              <>
                <Link href="/auth">
                  <Button variant="ghost" size="sm">
                    <LogIn className="h-4 w-4 mr-2" />
                    ログイン
                  </Button>
                </Link>
                <Link href="/auth">
                  <Button size="sm">
                    <UserPlus className="h-4 w-4 mr-2" />
                    新規登録
                  </Button>
                </Link>
              </>
            )}
          </div>
        </div>
      </div>
    </header>
  )
}
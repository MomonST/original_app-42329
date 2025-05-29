"use client"

import { useState } from 'react'
import { useAuth } from '@/hooks/useAuth'
import { Button } from '@/components/ui/Button'
import { Input } from '@/components/ui/Input'
import { Label } from '@/components/ui/Label'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/Card'

interface RegisterFormProps {
  onSuccess?: () => void
  onSwitchToLogin?: () => void
}

export function RegisterForm({ onSuccess, onSwitchToLogin }: RegisterFormProps) {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    password_confirmation: '',
    last_name: '',
    first_name: '',
    last_name_kana: '',
    first_name_kana: '',
    nickname: '',
    birth_date: ''
  })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const { register } = useAuth()

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    if (formData.password !== formData.password_confirmation) {
      setError('パスワードが一致しません')
      setLoading(false)
      return
    }

    const result = await register(formData)

    if (result.success) {
      onSuccess?.()
    } else {
      setError(result.error || '登録に失敗しました')
    }

    setLoading(false)
  }

  return (
    <Card className="w-full max-w-md mx-auto">
      <CardHeader>
        <CardTitle>新規登録</CardTitle>
        <CardDescription>
          アカウントを作成してください
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          {error && (
            <div className="p-3 text-sm text-red-600 bg-red-50 border border-red-200 rounded-md">
              {error}
            </div>
          )}

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="last_name">姓</Label>
              <Input
                id="last_name"
                name="last_name"
                value={formData.last_name}
                onChange={handleChange}
                required
                disabled={loading}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="first_name">名</Label>
              <Input
                id="first_name"
                name="first_name"
                value={formData.first_name}
                onChange={handleChange}
                required
                disabled={loading}
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="last_name_kana">姓（カタカナ）</Label>
              <Input
                id="last_name_kana"
                name="last_name_kana"
                value={formData.last_name_kana}
                onChange={handleChange}
                placeholder="ヤマダ"
                required
                disabled={loading}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="first_name_kana">名（カタカナ）</Label>
              <Input
                id="first_name_kana"
                name="first_name_kana"
                value={formData.first_name_kana}
                onChange={handleChange}
                placeholder="タロウ"
                required
                disabled={loading}
              />
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="nickname">ニックネーム</Label>
            <Input
              id="nickname"
              name="nickname"
              value={formData.nickname}
              onChange={handleChange}
              placeholder="やまちゃん"
              required
              disabled={loading}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="birth_date">生年月日</Label>
            <Input
              id="birth_date"
              name="birth_date"
              type="date"
              value={formData.birth_date}
              onChange={handleChange}
              required
              disabled={loading}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="email">メールアドレス</Label>
            <Input
              id="email"
              name="email"
              type="email"
              value={formData.email}
              onChange={handleChange}
              required
              disabled={loading}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="password">パスワード</Label>
            <Input
              id="password"
              name="password"
              type="password"
              value={formData.password}
              onChange={handleChange}
              required
              disabled={loading}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="password_confirmation">パスワード（確認）</Label>
            <Input
              id="password_confirmation"
              name="password_confirmation"
              type="password"
              value={formData.password_confirmation}
              onChange={handleChange}
              required
              disabled={loading}
            />
          </div>

          <Button 
            type="submit" 
            className="w-full" 
            disabled={loading}
          >
            {loading ? '登録中...' : '新規登録'}
          </Button>

          {onSwitchToLogin && (
            <div className="text-center">
              <Button
                type="button"
                variant="link"
                onClick={onSwitchToLogin}
                disabled={loading}
              >
                既にアカウントをお持ちの方はこちら
              </Button>
            </div>
          )}
        </form>
      </CardContent>
    </Card>
  )
}
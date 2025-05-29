"use client"

import { useState, useEffect, createContext, useContext, ReactNode } from 'react'
import { railsApi, User } from '@/lib/railsApi'

interface AuthContextType {
  user: User | null
  loading: boolean
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>
  register: (userData: {
    email: string
    password: string
    password_confirmation: string
    last_name: string
    first_name: string
    last_name_kana: string
    first_name_kana: string
    nickname: string
    birth_date: string
  }) => Promise<{ success: boolean; error?: string }>
  logout: () => void
  isAuthenticated: boolean
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // ページ読み込み時にトークンからユーザー情報を復元
    const token = localStorage.getItem('auth_token')
    if (token) {
      railsApi.setToken(token)
      // 簡易的にトークンの存在のみチェック
      // 実際のアプリではここでユーザー情報を取得
    }
    setLoading(false)
  }, [])

  const login = async (email: string, password: string) => {
    try {
      const response = await railsApi.login({ email, password })
      
      if (response.data) {
        const { user, token } = response.data
        setUser(user)
        railsApi.setToken(token)
        return { success: true }
      } else {
        return { success: false, error: response.error || 'ログインに失敗しました' }
      }
    } catch (error) {
      return { success: false, error: 'ネットワークエラーが発生しました' }
    }
  }

  const register = async (userData: {
    email: string
    password: string
    password_confirmation: string
    last_name: string
    first_name: string
    last_name_kana: string
    first_name_kana: string
    nickname: string
    birth_date: string
  }) => {
    try {
      const response = await railsApi.register(userData)
      
      if (response.data) {
        const { user, token } = response.data
        setUser(user)
        railsApi.setToken(token)
        return { success: true }
      } else {
        return { success: false, error: response.error || '登録に失敗しました' }
      }
    } catch (error) {
      return { success: false, error: 'ネットワークエラーが発生しました' }
    }
  }

  const logout = () => {
    setUser(null)
    railsApi.removeToken()
  }

  return (
    <AuthContext.Provider value={{
      user,
      loading,
      login,
      register,
      logout,
      isAuthenticated: !!user
    }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}
// Rails APIとの通信クライアント
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3001"

export interface ApiResponse<T> {
  data?: T
  error?: string
  message?: string
}

export interface User {
  id: number
  email: string
  nickname: string
  full_name: string
  full_name_kana: string
  created_at: string
}

export interface AuthResponse {
  user: User
  token: string
  message: string
}

export interface Flower {
  id: number
  name: string
  scientific_name?: string
  description?: string
  color?: string
  bloom_start_month: number
  bloom_end_month: number
  peak_month?: number
  difficulty_level: string
  difficulty_level_ja: string
  is_blooming_now: boolean
  days_until_bloom: number
}

export interface Mountain {
  id: number
  name: string
  elevation?: number
  prefecture: string
  elevation_category: string
}

export interface Region {
  id: number
  name: string
  code: string
}

export interface FlowerSpot {
  id: number
  flower: Flower
  mountain: Mountain
  best_viewing_time?: string
  notes?: string
}

export interface BloomPhoto {
  id: number
  url: string
  thumbnail_url: string
}

export interface BloomReport {
  id: number
  title: string
  description?: string
  bloom_status: string
  bloom_status_ja: string
  view_count: number
  likes_count: number
  status: string
  reported_at: string
  location_name: string
  flower_name: string
  user: User
  flower_spot: FlowerSpot
  photos?: BloomPhoto[]
  is_liked?: boolean
}

export interface RankingUser {
  rank: number
  user: User
  posts_count: number
  total_likes: number
}

export interface RankingReport {
  rank: number
  bloom_report: BloomReport
  likes_count?: number
  view_count?: number
}

class RailsApiClient {
  private baseURL: string
  private token: string | null = null

  constructor() {
    this.baseURL = `${API_BASE_URL}/api/v1`
    
    if (typeof window !== "undefined") {
      this.token = localStorage.getItem("auth_token")
    }
  }

  setToken(token: string) {
    this.token = token
    if (typeof window !== "undefined") {
      localStorage.setItem("auth_token", token)
    }
  }

  removeToken() {
    this.token = null
    if (typeof window !== "undefined") {
      localStorage.removeItem("auth_token")
    }
  }

  private async request<T>(endpoint: string, options: RequestInit = {}): Promise<ApiResponse<T>> {
    const url = `${this.baseURL}${endpoint}`

    // 型エラー修正：HeadersInitを明示的に型指定
    const headers: Record<string, string> = {
      "Content-Type": "application/json",
      ...(options.headers as Record<string, string>),
    }

    if (this.token) {
      headers.Authorization = `Bearer ${this.token}`
    }

    try {
      const response = await fetch(url, {
        ...options,
        headers,
      })

      const data = await response.json()

      if (!response.ok) {
        return { error: data.message || data.error || "エラーが発生しました" }
      }

      return { data }
    } catch (error) {
      console.error("API request error:", error)
      return { error: "ネットワークエラーが発生しました" }
    }
  }

  // 認証API
  async register(userData: {
    email: string
    password: string
    password_confirmation: string
    last_name: string
    first_name: string
    last_name_kana: string
    first_name_kana: string
    nickname: string
    birth_date: string
  }): Promise<ApiResponse<AuthResponse>> {
    return this.request<AuthResponse>("/auth/register", {
      method: "POST",
      body: JSON.stringify({ user: userData }),
    })
  }

  async login(credentials: {
    email: string
    password: string
  }): Promise<ApiResponse<AuthResponse>> {
    return this.request<AuthResponse>("/auth/login", {
      method: "POST",
      body: JSON.stringify({ user: credentials }),
    })
  }

  async logout(): Promise<ApiResponse<{ message: string }>> {
    return this.request<{ message: string }>("/auth/logout", {
      method: "DELETE",
    })
  }

  // 開花報告API
  async getBloomReports(params: {
    page?: number
    sort?: 'recent' | 'popular' | 'most_viewed'
    bloom_status?: string
    flower_id?: number
    region_id?: number
  } = {}): Promise<ApiResponse<{
    bloom_reports: BloomReport[]
    pagination: {
      current_page: number
      total_pages: number
      total_count: number
    }
  }>> {
    const queryString = new URLSearchParams(
      Object.entries(params).reduce((acc, [key, value]) => {
        if (value !== undefined) {
          acc[key] = String(value)
        }
        return acc
      }, {} as Record<string, string>)
    ).toString()

    return this.request<{
      bloom_reports: BloomReport[]
      pagination: {
        current_page: number
        total_pages: number
        total_count: number
      }
    }>(`/bloom_reports${queryString ? `?${queryString}` : ""}`)
  }

  async getBloomReport(id: number): Promise<ApiResponse<BloomReport>> {
    return this.request<BloomReport>(`/bloom_reports/${id}`)
  }

  async createBloomReport(formData: FormData): Promise<ApiResponse<{ bloom_report: BloomReport; message: string }>> {
    const url = `${this.baseURL}/bloom_reports`

    const headers: HeadersInit = {}
    if (this.token) {
      headers.Authorization = `Bearer ${this.token}`
    }

    try {
      const response = await fetch(url, {
        method: "POST",
        headers,
        body: formData,
      })

      const data = await response.json()

      if (!response.ok) {
        return { error: data.message || "投稿に失敗しました" }
      }

      return { data }
    } catch (error) {
      console.error("Create bloom report error:", error)
      return { error: "ネットワークエラーが発生しました" }
    }
  }

  async likeBloomReport(id: number): Promise<ApiResponse<{ message: string; likes_count: number }>> {
    return this.request<{ message: string; likes_count: number }>(`/bloom_reports/${id}/like`, {
      method: "POST",
    })
  }

  async unlikeBloomReport(id: number): Promise<ApiResponse<{ message: string; likes_count: number }>> {
    return this.request<{ message: string; likes_count: number }>(`/bloom_reports/${id}/unlike`, {
      method: "DELETE",
    })
  }

  // ランキングAPI
  async getUserRanking(): Promise<ApiResponse<{
    ranking_type: string
    rankings: RankingUser[]
  }>> {
    return this.request<{
      ranking_type: string
      rankings: RankingUser[]
    }>("/rankings/users")
  }

  async getLikesRanking(): Promise<ApiResponse<{
    ranking_type: string
    rankings: RankingReport[]
  }>> {
    return this.request<{
      ranking_type: string
      rankings: RankingReport[]
    }>("/rankings/likes")
  }

  async getViewsRanking(): Promise<ApiResponse<{
    ranking_type: string
    rankings: RankingReport[]
  }>> {
    return this.request<{
      ranking_type: string
      rankings: RankingReport[]
    }>("/rankings/views")
  }

  // 花・山データAPI
  async getFlowers(): Promise<ApiResponse<Flower[]>> {
    return this.request<Flower[]>("/flowers")
  }

  async getMountains(): Promise<ApiResponse<Mountain[]>> {
    return this.request<Mountain[]>("/mountains")
  }

  async getRegions(): Promise<ApiResponse<Region[]>> {
    return this.request<Region[]>("/regions")
  }

  async getFlowerSpots(): Promise<ApiResponse<FlowerSpot[]>> {
    return this.request<FlowerSpot[]>("/flower_spots")
  }
}

export const railsApi = new RailsApiClient()


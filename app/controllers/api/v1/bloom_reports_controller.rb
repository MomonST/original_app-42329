class Api::V1::BloomReportsController < Api::V1::BaseController
  before_action :authenticate_user!, except: [:index, :show, :rankings]
  before_action :set_bloom_report, only: [:show, :update, :destroy, :like, :unlike]

  # GET /api/v1/bloom_reports
  def index
    @bloom_reports = BloomReport.approved.includes(:user, :flower_spot, :likes, photos_attachments: :blob)
    
    # フィルタリング
    @bloom_reports = @bloom_reports.by_bloom_status(params[:bloom_status]) if params[:bloom_status].present?
    @bloom_reports = @bloom_reports.joins(:flower_spot).where(flower_spots: { flower_id: params[:flower_id] }) if params[:flower_id].present?
    @bloom_reports = @bloom_reports.joins(flower_spot: :mountain).where(mountains: { region_id: params[:region_id] }) if params[:region_id].present?
    
    # ソート
    case params[:sort]
    when 'popular'
      @bloom_reports = @bloom_reports.popular
    when 'most_viewed'
      @bloom_reports = @bloom_reports.most_viewed
    when 'recent'
      @bloom_reports = @bloom_reports.recent
    else
      @bloom_reports = @bloom_reports.recent
    end

    @bloom_reports = @bloom_reports.page(params[:page]).per(20)

    render json: {
      bloom_reports: @bloom_reports.map { |report| BloomReportSerializer.new(report).as_json },
      pagination: {
        current_page: @bloom_reports.current_page,
        total_pages: @bloom_reports.total_pages,
        total_count: @bloom_reports.total_count
      }
    }
  end

  # GET /api/v1/bloom_reports/:id
  def show
    @bloom_report.increment_view_count!
    
    render json: BloomReportSerializer.new(@bloom_report, include_photos: true).as_json
  end

  # POST /api/v1/bloom_reports
  def create
    @bloom_report = current_user.bloom_reports.build(bloom_report_params)
    
    if @bloom_report.save
      render json: {
        message: '開花報告を投稿しました！審査後に公開されます。',
        bloom_report: BloomReportSerializer.new(@bloom_report).as_json
      }, status: :created
    else
      render json: {
        message: '投稿に失敗しました',
        errors: @bloom_report.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/bloom_reports/:id
  def update
    if @bloom_report.user == current_user && @bloom_report.update(bloom_report_params)
      render json: {
        message: '投稿を更新しました',
        bloom_report: BloomReportSerializer.new(@bloom_report).as_json
      }
    else
      render json: {
        message: '更新に失敗しました',
        errors: @bloom_report.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/bloom_reports/:id
  def destroy
    if @bloom_report.user == current_user && @bloom_report.destroy
      render json: { message: '投稿を削除しました' }
    else
      render json: { message: '削除に失敗しました' }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/bloom_reports/:id/like
  def like
    like = current_user.likes.find_or_initialize_by(bloom_report: @bloom_report)
    
    if like.persisted?
      render json: { message: '既にいいねしています' }, status: :unprocessable_entity
    elsif like.save
      render json: { 
        message: 'いいねしました',
        likes_count: @bloom_report.reload.likes_count
      }
    else
      render json: { message: 'いいねに失敗しました' }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/bloom_reports/:id/unlike
  def unlike
    like = current_user.likes.find_by(bloom_report: @bloom_report)
    
    if like&.destroy
      render json: { 
        message: 'いいねを取り消しました',
        likes_count: @bloom_report.reload.likes_count
      }
    else
      render json: { message: 'いいねの取り消しに失敗しました' }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/bloom_reports/rankings
  def rankings
    case params[:type]
    when 'users_by_posts'
      #ユーザー投稿数ランキング
      users = User.joins(:bloom_reports)
                  .where(bloom_reports: { status: :approved })
                  .group('users.id')
                  .select(
                    'users.id, users.nickname, COUNT(bloom_reports.id) AS posts_count, SUM(bloom_reports.likes_count) AS total_likes'
                  )
                  .order('posts_count DESC')
                  .limit(10)
                  
      render json: {
        ranking_type: 'ユーザー投稿数ランキング',
        rankings: users.map.with_index(1) do |user, rank|
          {
            rank: rank,
            user_id: user[:id],
            nickname: user[:nickname],
            posts_count: user.posts_count,
            total_likes: user.total_likes_received
          }
        end
      }
    
    when 'posts_by_likes'
      # 投稿いいね数ランキング
      reports = BloomReport.approved.popular.limit(10).includes(:user, :flower_spot)
      
      render json: {
        ranking_type: '投稿いいね数ランキング',
        rankings: reports.map.with_index(1) do |report, rank|
          {
            rank: rank,
            bloom_report: BloomReportSerializer.new(report).as_json,
            likes_count: report.likes_count
          }
        end
      }
    
    when 'posts_by_views'
      # 投稿閲覧数ランキング
      reports = BloomReport.approved.most_viewed.limit(10).includes(:user, :flower_spot)
      
      render json: {
        ranking_type: '投稿閲覧数ランキング',
        rankings: reports.map.with_index(1) do |report, rank|
          {
            rank: rank,
            bloom_report: BloomReportSerializer.new(report).as_json,
            view_count: report.view_count
          }
        end
      }
    
    else
      render json: { error: '無効なランキングタイプです' }, status: :bad_request
    end
  end

  private

  def set_bloom_report
    @bloom_report = BloomReport.find(params[:id])
  end

  def bloom_report_params
    params.require(:bloom_report).permit(
      :flower_spot_id, :title, :description, :bloom_status, 
      photos: []
    )
  end
end
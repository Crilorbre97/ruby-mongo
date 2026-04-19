class FilterArticles
  attr_reader :articles

  def initialize(articles = initial_scope)
    @articles = articles
  end

  def call(params = {})
    scoped = articles
    scoped = filter_by_title(scoped, params[:title])

    sorting(scoped)
  end

  private

  def initial_scope
    Article.all
  end

  def filter_by_title(scoped, title)
    return scoped unless title.present?

    scoped.where(title: /#{title}/i)
  end

  def sorting(scoped)
    scoped.order(created_at: :desc)
  end
end

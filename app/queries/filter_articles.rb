class FilterArticles
  attr_reader :articles

  def initialize(articles = initial_scope)
    @articles = articles
  end

  def call(params = {})
    scoped = articles
    scoped = filter_by_title(scoped, params[:title])
    scoped = filter_by_tag(scoped, params[:tag])
    scoped = filter_by_start_date(scoped, params[:start_date])
    scoped = filter_by_end_date(scoped, params[:end_date])
    scoped = sorting(scoped)
    Pagination.new(scoped, params[:page]).call
  end

  private

  def initial_scope
    Article.all
  end

  def filter_by_title(scoped, title)
    return scoped unless title.present?

    scoped.where(title: /#{title}/i)
  end

  def filter_by_tag(scoped, tag)
    return scoped unless tag.present?

    scoped.in(tags: tag)
  end

  def filter_by_start_date(scoped, start_date)
    return scoped unless start_date.present?

    begin
      date = Date.strptime(start_date, "%d/%m/%Y")
      scoped.where(created_at: { '$gte': date })
    rescue
      scoped
    end
  end

  def filter_by_end_date(scoped, end_date)
    return scoped unless end_date.present?

    begin
      date = Date.strptime(end_date, "%d/%m/%Y")
      scoped.where(created_at: { '$lte': date })
    rescue
      scoped
    end
  end

  def sorting(scoped)
    scoped.order(created_at: :desc)
  end
end

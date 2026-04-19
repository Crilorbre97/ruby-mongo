class Pagination
  DEFAULT_PER_PAGE = 10

  attr_reader :records, :count, :page, :per_page

  def initialize(records, page)
    @records = records
    @count = records.count
    @page = page.to_i
    @per_page = DEFAULT_PER_PAGE
  end

  def call
    {
      data: records.skip(page * per_page).limit(per_page),
      total: count,
      currentPage: page.to_i,
      totalPages: (count/per_page).ceil
    }
  end
end

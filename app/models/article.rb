class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :body, type: String
  field :published, type: Mongoid::Boolean, default: false
  field :published_at, type: Date
  field :tags, type: Array

  belongs_to :author

  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true, length: { minimum: 10 }

  before_save :set_published_at

  private

  def set_published_at
    return unless published

    self.published_at = Date.current
  end
end

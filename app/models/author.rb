class Author
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :lastname, type: String
  field :email, type: String
  field :city, type: String
  field :birth_date, type: Date

  has_many :articles, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: :invalid
    }
  validates :email, uniqueness: true, if: -> { email.present? }
  validates :city, presence: true
  validates :birth_date, presence: true

  index({ email: 1 }, { name: "email_index", unique: true })

  before_save :downcase_attributes

  private

  def downcase_attributes
    self.email = email.downcase
  end
end

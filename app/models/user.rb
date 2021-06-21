class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: %i(google_oauth2 facebook twitter)

  has_many :documents, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :todo_lists, dependent: :destroy

  validates :name, { presence: true, length: { maximum: 60 } }
  validates :email, { presence: true, uniqueness: true }

  attachment :profile_image

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゆうしゃ"
    end
  end

  def self.from_omniauth(auth)
    find_or_create_by!(email: auth.info.email) do |user|
      user.name = auth.info.email
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end

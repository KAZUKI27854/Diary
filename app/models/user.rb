class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :documents, dependent: :destroy
  has_many :goals, dependent: :destroy

  validates :name, {presence: true, length: {maximum: 10}}

  attachment :profile_image

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゆうしゃ"
    end
  end
end

class User < ApplicationRecord
  self.primary_key = 'id'
  self.table_name = 'users'

  has_many :my_strategy_infos
  has_many :api_key

  # user 삭제시 삭제된 user의 my_strategy_infos 비활성화
  after_destroy :deactivate_my_strategy_infos

  def deactivate_my_strategy_infos
    my_strategy_infos.update_all(active_yn: 'N')
  end

  scope :active_my_strategy_infos, -> {
    joins(:my_strategy_infos).where(my_strategy_infos: { active_yn: 'Y' })
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image

      # user.email = auth.info.email
      # user.password = Devise.friendly_token[0, 20]
      # user.name = auth.info.name   # 사용자 이름을 저장하고 싶을 경우
      # user.image = auth.info.image # 사용자 이미지 URL을 저장하고 싶을 경우
    end
  end
end
class Micropost < ActiveRecord::Base
  belongs_to :user
  #图片上传,这个方法的第一个参数是属性 的符号形式,第二个参数是上传程序的类名:
  mount_uploader :picture, PictureUploader
  #设置显示顺序
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence:true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size


  private

    def picture_size
      if picture.size >5.megabytes
        self.errors.add(:picture, "should be less than 5MB")
      end
    end


end

class User < ActiveRecord::Base


	before_save {self.email = email.downcase}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length:{maximum: 50}
	validates :email, presence: true , length:{maximum: 255},
									format: { with: VALID_EMAIL_REGEX  },
									uniqueness: { case_sensitive: false}
	# 在数据库中的password_digest列存储安全的密码哈希值;
    # 获得一对“虚拟属性”,17password和password_confirmation,而且创建用户对象时会执行存在性验证
    #和匹配验证;
    #获得authenticate方法,如果密码正确,返回对应的用户对象,否则返回false。

	has_secure_password

	validates :password, presence: true, length:{minimum: 6}


end

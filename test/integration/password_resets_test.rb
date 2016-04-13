require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest


def setup
  ActionMailer::Base.deliveries.clear
  @user = users(:michael)
end

test 'password resets' do
  get new_password_reset_path
  assert_template 'password_resets/new'
  #电子邮箱地址无效
  post password_resets_path, password_reset: { email: ""}
  assert_not flash.empty?
  assert_template 'password_resets/new'
  #电子邮箱地址有效
  post password_resets_path, password_reset: { email: @user.email}
  #这里有一个function做了digest的值修改，所以要reload一下
  assert_not_equal @user.reset_digest, @user.reload.reset_digest
  assert_equal 1, ActionMailer::Base.deliveries.size
  assert_not flash.empty?
  assert_redirected_to root_url
  #密码重置表单, 不太理解这个assigns
  user = assigns(:user)
  #电子邮件地址错误
  get edit_password_reset_path(user.reset_token, email:"")
  assert_redirected_to root_url
  #用户未激活
  user.toggle!(:activated)
  get edit_password_reset_path(user.reset_token, email: user.email)
  assert_redirected_to root_url
  user.toggle!(:activated)
  #电子邮箱正确，但令牌不对
  get edit_password_reset_path("wong token", email: user.email)
  assert_redirected_to root_url
  #电子邮箱正确，令牌也对
  get edit_password_reset_path(user.reset_token, email: user.email)
  assert_template 'password_resets/edit'
  #这行代码的意思是,页面中有 name 属性、类型(隐藏)和电子邮件地址都正确的
  #input 标签: <input id="email" name="email" type="hidden" value="michael@example.com" />
  assert_select "input[name=email][type=hidden][value=?]", user.email
  # 密码和密码确认不匹配
  patch password_reset_path(user.reset_token),
        email: user.email,
        user: { password:              "foobaz",
                password_confirmation: "barquux" }
  assert_select 'div#error_explanation'
# 密码为空值
  patch password_reset_path(user.reset_token),
        email: user.email,
        user: { password:              "",
                password_confirmation: "" }
  assert_select 'div#error_explanation'
# 密码和密码确认有效
  patch password_reset_path(user.reset_token),
        email: user.email,
        user: { password:              "foobaz",
                password_confirmation: "foobaz" }
  assert is_logged_in?
  assert_not flash.empty?
  assert_redirected_to user
end

end

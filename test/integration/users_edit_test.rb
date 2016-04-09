require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), user: {name: '',email:'foo@invalid',
                                  password: '123', password_confirmation: '321'}
    assert_template 'users/edit'
  end

  test "successfully edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = @user.name+'1'
    email = '1'+@user.email
    patch user_path(@user), user: {name: name, email: email,
                                  password:  "",
                                  password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end


  test "successfully edit with friendsly forwarding" do

    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "foo bar"
    email = "foo@bar.com"
    patch user_path(@user), user: {name: name, email: email, password: "",
                                    password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end


end

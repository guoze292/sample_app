require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do 
  	get signup_path
  	#不懂
  	assert_no_difference 'User.count' do
  		#post 到users_path 其实就是调用了users的resources里的post功能，指向create
  		
  		post users_path, user: {name:"",
  								email:"user@invalid",
  								password:"food",
  								password_confirmation:"bar"}
  	end
  	assert_template 'users/new'
 end


 test "valid signup information" do
 	get signup_path
 	name = "example"
 	email = "user@baidu.com"
 	passwrod = "password"
 	assert_difference 'User.count', 1 do
 		post_via_redirect users_path, user{
 			name: name, email: email, password: password, 
 			password_confirmation:password
 		}
 	end
 	assert_template 'users/show'
 end



end

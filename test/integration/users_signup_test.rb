require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invaild signup information' do
    get signup_path 

    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '', email: 'user@invaild', password: 'hoge', password_confirmation: 'fuga'}}
    end
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test 'vaild signup infromation' do
    get signup_path
      assert_difference 'User.count', 1 do
        post users_path, params: { user: { name: 'test user', email: 'user@example.com', password: 'hogehoge', password_confirmaton: 'hogehoge'}}
      end
      follow_redirect!
      assert_template 'users/show'
      assert_not flash.empty?
  end
end

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: '',
                                            email: 'foosasinvalid',
                                            password: 'foo',
                                            password_confirmation: 'bar'}}

    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors.'
  end

  test 'succesful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    name = 'hoge'
    email = 'fuga@fuga.jp'
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: name,
                                            email: email,
                                            password: '',
                                            password_confirmation: ''}}

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'succsessful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'updated name'
    email = 'updated_email@example.com'
    patch user_path(@user), params: {user: {name: name, 
                                            email: email,
                                            password: '',
                                            password_confirmation: ''}}
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
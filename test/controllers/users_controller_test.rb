require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @not_activated = users(:john)
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path 
    assert_response :success
    assert_select 'title', full_title('Sign up')
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: {user: { name: @user.name,
                                             email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: {user: {name: 'wrong',
                                           email: 'wrong@miss.com'}}
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should not allow admin attribute to be edited via web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {user: {name: 'hoge',
                                                  email: 'hoge@fugaaaa.com',
                                                  admin: true}}
    assert_not @other_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should rdirect destroy when logged in as a non-admin user' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test 'succsesful delete user' do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_not flash.empty?
    assert_redirected_to users_path
  end

  test 'should redirect to root url when get user path not activated' do
    log_in_as(@user)
    get user_path(@not_activated)
    assert_redirected_to root_url
  end
end

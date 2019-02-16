require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", full_title 
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", full_title('Help')
  end

  test "should be get about" do
    get about_path
    assert_response :success
    assert_select "title", full_title('About')
  end

  test "should be get contact" do
    get contact_path
    assert_response :success
    assert_select "title", full_title('Contact')
  end
end

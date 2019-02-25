require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'sato hikaru', email: 'test@exeample.com', password: 'password', password_confirmation: 'password')
  end

  test 'should be vaild' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '    '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(hoge@exapmle.com fuga@exapmle.com hoo@example.com bar@exapmle.com)
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'email validation should not accept invalid addresses' do
    invalid_addresses = %w(hoge@exapmle,com fugaexapmle.com hoo@example.hoge+com bar@exapmle. hogehoge@fuga..com)
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = "HogesadSAdfAS@SADFASpd.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have minimum lenght' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end

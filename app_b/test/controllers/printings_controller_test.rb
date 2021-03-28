require "test_helper"

class PrintingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @printing = printings(:one)
  end

  test "should get index" do
    get printings_url
    assert_response :success
  end

  test "should get new" do
    get new_printing_url
    assert_response :success
  end

  test "should create printing" do
    assert_difference('Printing.count') do
      post printings_url, params: { printing: {  } }
    end

    assert_redirected_to printing_url(Printing.last)
  end

  test "should show printing" do
    get printing_url(@printing)
    assert_response :success
  end

  test "should get edit" do
    get edit_printing_url(@printing)
    assert_response :success
  end

  test "should update printing" do
    patch printing_url(@printing), params: { printing: {  } }
    assert_redirected_to printing_url(@printing)
  end

  test "should destroy printing" do
    assert_difference('Printing.count', -1) do
      delete printing_url(@printing)
    end

    assert_redirected_to printings_url
  end
end

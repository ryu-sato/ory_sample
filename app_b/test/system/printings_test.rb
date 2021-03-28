require "application_system_test_case"

class PrintingsTest < ApplicationSystemTestCase
  setup do
    @printing = printings(:one)
  end

  test "visiting the index" do
    visit printings_url
    assert_selector "h1", text: "Printings"
  end

  test "creating a Printing" do
    visit printings_url
    click_on "New Printing"

    click_on "Create Printing"

    assert_text "Printing was successfully created"
    click_on "Back"
  end

  test "updating a Printing" do
    visit printings_url
    click_on "Edit", match: :first

    click_on "Update Printing"

    assert_text "Printing was successfully updated"
    click_on "Back"
  end

  test "destroying a Printing" do
    visit printings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Printing was successfully destroyed"
  end
end

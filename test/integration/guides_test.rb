require "test_helper"

class GuidesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  DRAFT = Guide::ALL.first

  test "draft guides are hidden from visitors" do
    skip "every guide is published" if Guide::ALL.all?(&:published)

    get guides_path
    assert_response :success
    assert_select ".guide-card[href='#{guide_path(slug: DRAFT.slug)}']", count: 0

    get guide_path(slug: DRAFT.slug)
    assert_response :not_found
  end

  test "admins can preview drafts, which are marked and not indexed" do
    sign_in users(:admin)
    get guide_path(slug: DRAFT.slug)
    assert_response :success
    assert_select "h1", DRAFT.title
    assert_select ".guide__head .badge", /Borrador/ unless DRAFT.published
    assert_select "meta[name=robots][content^='noindex']" unless DRAFT.published
    assert_select "script[type='application/ld+json']", /"@type":"Article"/
  end

  test "every guide has its article template" do
    sign_in users(:admin)
    Guide::ALL.each do |guide|
      get guide_path(slug: guide.slug)
      assert_response :success, "#{guide.slug} should render"
      assert_select ".guide__body h2", minimum: 3
    end
  end
end

require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { amazon_url: @product.amazon_url, author: @product.author, category_id: @product.category_id, isbn: @product.isbn, medium_image_url: @product.medium_image_url, pages: @product.pages, price: @product.price, publisher: @product.publisher, small_image_url: @product.small_image_url, title: @product.title }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { amazon_url: @product.amazon_url, author: @product.author, category_id: @product.category_id, isbn: @product.isbn, medium_image_url: @product.medium_image_url, pages: @product.pages, price: @product.price, publisher: @product.publisher, small_image_url: @product.small_image_url, title: @product.title }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end

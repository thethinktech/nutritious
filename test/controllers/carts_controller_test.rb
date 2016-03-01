require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @cart = carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cart" do
    assert_difference('Cart.count') do
      post :create, cart: { cart_id: @cart.cart_id, cart_item_id: @cart.cart_item_id, hmac: @cart.hmac, price: @cart.price, purchase_url: @cart.purchase_url, quantity: @cart.quantity, title: @cart.title, user_id: @cart.user_id }
    end

    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should show cart" do
    get :show, id: @cart
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cart
    assert_response :success
  end

  test "should update cart" do
    patch :update, id: @cart, cart: { cart_id: @cart.cart_id, cart_item_id: @cart.cart_item_id, hmac: @cart.hmac, price: @cart.price, purchase_url: @cart.purchase_url, quantity: @cart.quantity, title: @cart.title, user_id: @cart.user_id }
    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should destroy cart" do
    assert_difference('Cart.count', -1) do
      delete :destroy, id: @cart
    end

    assert_redirected_to carts_path
  end
end

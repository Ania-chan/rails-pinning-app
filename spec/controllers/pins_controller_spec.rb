require 'spec_helper'
RSpec.describe PinsController do
  before(:each) do 
    @user = FactoryGirl.create(:user_with_boards)
    login(@user)
    @board_pinner = BoardPinner.create(user: @user, board: FactoryGirl.create(:board))
  end

  after(:each) do
    if !@user.destroyed?
      @user.pinnings.destroy_all
      @user.boards.destroy_all 
      @user.destroy
    end
  end

  describe "GET index" do
    
    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end

    it 'populates @pins with all pins' do
      get :index
      expect(assigns[:pins]).to eq(Pin.all)
    end

  end

  describe "GET new" do
    it 'responds with successfully' do
      get :new
      expect(response.success?).to be(true)
    end
    
    it 'renders the new view' do
      get :new      
      expect(response).to render_template(:new)
    end
    
    it 'assigns an instance variable to a new pin' do
      get :new
      expect(assigns(:pin)).to be_a_new(Pin)
    end

    it 'redirects to Login when logged out' do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end

    it 'assigns @pinnable_boards to all pinnable boards' do
      get :new
      expect(assigns[:pinnable_boards]).to eq(@pinnable_boards)
    end
  end
  
  describe "POST create" do
    before(:each) do
      @pin_hash = { 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: 1,
        image: nil,
        user_id: @user.id}    
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with a redirect' do
      post :create, params: { pin: @pin_hash }
      expect(response.redirect?).to be(true)
    end
    
    it 'creates a pin' do
      post :create, params: { pin: @pin_hash }
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end
    
    it 'redirects to the show view' do
      post :create, params: { pin: @pin_hash }
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end
    
    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, params: { pin: @pin_hash }
      expect(response).to render_template(:new)
    end
    
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, params: { pin: @pin_hash }
      expect(assigns[:errors].present?).to be(true)
    end   
    
    it 'redirects to Login when logged out' do
      logout(@user)
      post :create, params: { pin: @pin_hash }
      expect(response).to redirect_to(:login)
    end

    it 'pins to a board for which the user is a board_pinner' do
      @pin_hash[:pinnings_attributes] = []
      board = @board_pinner.board
      @pin_hash[:pinnings_attributes] << {board_id: board.id, user_id: @user.id}
      post :create, params: { pin: @pin_hash }
      pinning = BoardPinner.where("user_id=? AND board_id=?", @user.id, board.id)

      if pinning.present?
        pinning.destroy_all
      end
    end
  end

  describe "GET edit_by_name" do
    before(:each) do
      @pin_hash = Pin.create( 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: 1,
        image: nil,
        user_id: @user.id)   
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end

    it 'responds with successfully' do
      get :edit_by_name, params: { slug: @pin_hash.slug }
      expect(response.success?).to be(true)
    end
    
    it 'renders the edit view' do
      get :edit_by_name, params: { slug: @pin_hash.slug }
      expect(response).to render_template(:edit)
    end
    
    it 'assigns an instance variable to an existing pin' do
      get :edit_by_name, params: { slug: @pin_hash.slug }
      expect(assigns(:pin)).to eq(@pin_hash)
    end

    it 'redirects to Login when logged out' do
      logout(@user)
      get :edit_by_name, params: { slug: @pin_hash.slug }
      expect(response).to redirect_to(:login)
    end
  end

  describe "PATCH update" do
    before(:each) do
      @pin_hash = Pin.create(
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: 1,
        image: nil,
        user_id: @user.id
      )   
      @updated_pin = {
        title: "New Title", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: 1,
        image: nil
      }    
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with a redirect' do
      patch :update, params: { id: @pin_hash.id, pin: @updated_pin }
      expect(response.redirect?).to be(true)
    end
    
    it 'updates a pin' do
      patch :update, params: { id: @pin_hash.id, pin: @updated_pin }
      expect(@pin_hash.reload.title == "New Title").to be(true)
    end
    
    it 'redirects to the show view' do
      patch :update, params: { id: @pin_hash.id, pin: @updated_pin }
      expect(response).to redirect_to(pin_url(assigns(:pin)))
    end
    
    it 'redisplays edit form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      patch :update, params: { id: @pin_hash.id, pin: { title: nil } }
      expect(response).to render_template(:edit)
    end
    
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @updated_pin.delete(:title)
      patch :update, params: { id: @pin_hash.id, pin: { title: nil } }
      expect(assigns[:errors].present?).to be(true)
    end   
    
    it 'redirects to Login when logged out' do
      logout(@user)
      patch :update, params: { id: @pin_hash.id, pin: { title: nil } }
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST repin" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login(@user)
      @board = FactoryGirl.create(:board)
      @pin = FactoryGirl.create(:pin)
    end

    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      pinning = Pinning.find_by_user_id(@user.id)
      if !pin.nil?
        pinning.destroy
        pin.destroy
      end
      logout(@user)
    end

    it 'responds with a redirect' do
      post :repin, params: { id: @pin.id, pin: {pinning: { board_id: @board.id, user_id: @user.id} } }
      expect(response.redirect?).to be(true)
    end

    it 'creates a user.pin' do
      post :repin, params: { id: @pin.id, pin: {pinning: { board_id: @board.id, user_id: @user.id} } }
      expect(@user.pins).to include(@pin)
    end

    it 'redirects to the board show page' do
      post :repin, params: { id: @pin.id, pin: {pinning: { board_id: @board.id, user_id: @user.id} } }
      expect(response).to redirect_to(board_path(@board.id))
    end

    it 'creates a pinning to a board on which the user is a board_pinner' do
      @pin_hash = {
        title: @pin.title, 
        url: @pin.url, 
        slug: @pin.slug, 
        text: @pin.text,
        category_id: @pin.category_id
      }
      board = @board_pinner.board
      @pin_hash[:pinning] = {board_id: board.id}
      post :repin, params: { id: @pin.id, pin: @pin_hash }
      pinning = BoardPinner.where("board_id=?", board.id)
      expect(pinning.present?).to be(true)
      
      if pinning.present?
        pinning.destroy_all
      end
    end    
  end

end
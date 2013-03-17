require 'spec_helper'

describe AuthenticationConcern, :type => :controller do
  controller do
    before_filter :require_authentication!

    def index
      head :ok
    end
  end

  shared_examples 'user is logged in' do
    let(:user) { create(:user) }
    before { controller.login!(user) }
  end

  shared_examples 'user is logged out' do
    before { controller.logout! }
  end

  describe '#current_user' do
    with_context 'user is logged in' do
      it 'returns the user whose ID is in the session' do
        controller.current_user.should eq user
      end
    end

    with_context 'user is logged out' do
      it 'returns nil' do
        controller.current_user.should be_nil
      end
    end
  end

  describe '#logged_in?' do
    with_context 'user is logged in' do
      it 'returns true' do
        controller.should be_logged_in
      end
    end

    context 'when user is not logged in' do
      it 'returns false' do
        controller.should_not be_logged_in
      end
    end
  end

  describe '#logout!' do
    with_context 'user is logged in' do
      it 'logs the user out' do
        expect {
          controller.logout!
        }.to change(controller, :logged_in?).from(true).to(false)
      end

      it 'sets the current_user to nil' do
        expect {
          controller.logout!
        }.to change(controller, :current_user).to(nil)
      end
    end

    with_context 'user is logged out' do
      it 'does not changed logged_in? status' do
        expect {
          controller.logout!
        }.to_not change(controller, :logged_in?)

      end
    end
  end

  describe '#require_authentication!' do
    with_context 'user is logged in' do
      it 'lets the user see the page' do
        get 'index'
        response.should be_success
      end
    end

    with_context 'user is logged out' do
      it 'redirects the user to the root path' do
        get 'index'
        response.should redirect_to(root_path)
      end
    end
  end
end

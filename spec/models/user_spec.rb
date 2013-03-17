require 'spec_helper'

describe User do
  describe '#valid?' do
    it { should validate_presence_of(:username) }
    it { should ensure_length_of(:username).is_at_least(2).is_at_most(32) }

    it { should validate_presence_of(:email) }

    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }

    context 'when a user already exists' do
      before { create(:user) }

      it { should validate_uniqueness_of(:username).case_insensitive }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe '#save' do
    let(:user) { build(:user) }

    it 'downcases email before saving' do
      user.email = 'ALLCAPS@example.com'

      expect {
        user.save
      }.to change(user, :email).from('ALLCAPS@example.com').to('allcaps@example.com')
    end
  end

  describe '.authenticate' do
    let!(:user) { create(:user, :email => 'user@example.com', :password => 'password') }

    context 'when credentials are valid' do
      it 'returns the corresponding user' do
        User.authenticate('user@example.com', 'password').should eq user
      end
    end

    context 'when email is invalid' do
      it 'returns false' do
        User.authenticate('kajsdjkh@example.com', 'password').should be_false
      end
    end

    context 'when password is invalid' do
      it 'returns false' do
        User.authenticate('user@example.com', 'foobar').should be_false
      end
    end
  end
end

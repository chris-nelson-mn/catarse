#encoding:utf-8
require 'spec_helper'

describe UsersController do
  render_views
  subject{ response }
  before do
    controller.stub(:current_user).and_return(current_user)
  end

  let(:successful_project){ create(:project, state: 'successful') }
  let(:failed_project){ create(:project, state: 'failed') }
  let(:contribution){ create(:contribution, state: 'confirmed', user: user, project: failed_project) }
  let(:user){ create(:user, password: 'current_password', password_confirmation: 'current_password', authorizations: [create(:authorization, uid: 666, oauth_provider: create(:oauth_provider, name: 'facebook'))]) }
  let(:current_user){ user }

  describe "GET unsubscribe_notifications" do
    context "when user is loged" do
      before do
        get :unsubscribe_notifications, id: user.id, locale: 'pt'
      end

      it { should redirect_to user_path(user, anchor: 'unsubscribes')  }
    end

    context "when user is not loged" do
      let(:current_user) { nil }
      before do
        get :unsubscribe_notifications, id: user.id, locale: 'pt'
      end

      it { should_not redirect_to user_path(user, anchor: 'unsubscribes')  }
    end
  end

  describe "PUT update" do
    before do
      put :update, id: user.id, locale: 'pt', user: { twitter: 'test' }
    end
    it("should update the user") do
      user.reload
      user.twitter.should ==  'test'
    end
    it{ should redirect_to user_path(user, anchor: 'settings') }
  end

  describe "PUT update_password" do
    let(:current_password){ 'current_password' }
    let(:password){ 'newpassword123' }
    let(:password_confirmation){ 'newpassword123' }
    before do
      put :update_password, id: user.id, locale: 'pt', user: { current_password: current_password, password: password, password_confirmation: password_confirmation }
    end

    context "with wrong current password" do
      let(:current_password){ 'wrong_password' }
      it{ flash[:error].should_not be_empty }
      it{ should redirect_to user_path(user, anchor: 'settings') }
    end

    context "with right current password and right confirmation" do
      it{ flash[:notice].should_not be_empty }
      it{ flash[:error].should be_nil }
      it{ should redirect_to user_path(user, anchor: 'settings') }
    end
  end

  describe "GET show" do
    before do
      get :show, id: user.id, locale: 'pt'
    end

    context "when user is no longer active" do
      let(:user){ create(:user, deactivated_at: Time.now) }
      its(:status){ should eq 404 }
    end

    context "when user is active" do
      it{ should be_successful }
      it{ assigns(:fb_admins).should include(user.facebook_id.to_i) }
    end
  end
end

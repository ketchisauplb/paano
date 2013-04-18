require 'spec_helper'

describe "Filtering current user's question i.e. clicking the 'Mine' link at home" do
  before(:each) do
    @user = FactoryGirl.create(:user_facebook)
    @question_1 = FactoryGirl.create(:question, user: @user)
    @question_2 = FactoryGirl.create(:question) #noise question
    visit root_path
    current_path.should eq root_path 
  end

  it "fails because user is not signed-in" do
    click_link I18n.t('shared.home.left.mine') 
    current_path.should eq new_user_session_path
  end

  it "succeeds because user is signed-in" do
    click_link I18n.t('shared.navbar.user_links.sign_in_with_facebook')
    click_link I18n.t('shared.home.left.mine') 
    page.should have_content @question_1.title
    page.should_not have_content @question_2.title
  end
end

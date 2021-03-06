require 'spec_helper'

describe QuestionsController do
  include_context "common controller stuff"

  describe "index" do
    before(:each) do
      @question = FactoryGirl.create(:question)
      @question_with_an_answer = FactoryGirl.create(:question_with_an_answer)
    end

    it "returns all unanswered questions" do
      xhr :get, :unanswered
      assigns(:questions).should eq [@question]
    end

    it "returns all hot questions" do
      pending
    end

    describe "returns the current users' questions" do
      it "fails because there's no user signed in" do
        xhr :get, :mine
        should_be_unauthorized_access
      end

      it "succeeds because there's a user signed in" do
        @user = sign_in_user
        #refactor the above block

        question = FactoryGirl.create(:question, user: @user)
        FactoryGirl.create(:question) # noise question
        # @question created above is the noise question
        xhr :get, :mine
        assigns(:questions).should eq [question]
      end
    end

    it "returns all the questions in DESC order by date created" do
      pending
    end
  end

  describe "new" do
    describe "succeeds" do
      login_user      
      it "goes to questions/new" do
        xhr :get, :new  
        response.should be_success
        response.should render_template(:new)
      end
    end

    describe "fails" do 
      describe "when user not logged in" do
        it "unsucessfully goes to posts/new" do 
          xhr :get, :new
          response.status.should eq 401 #unauthorized access
        end
      end
    end
  end

  describe "create" do
    let(:params) {{"question" => {"title" => "Question Title", "content" => "Question Content", "tag_list" => "tag_1, tag_2", "answers_attributes"=>{"0"=>{"content"=>""}}}}}

    describe "success" do
      login_user 

      it "creates a new question and the first answer to that question if the user filled in an answer to the question" do
        params["question"]["answers_attributes"]["0"]["content"] = "My Answer"

        expect {
          expect {
            xhr :post, :create, params
          }.to change(Question, :count).by 1
        }.to change(Answer, :count).by 1
      end
    end

    describe "fail" do
      describe "while user signed it" do
        login_user 

        it "does not create a question if it does not have a title" do
          params['question']['title'] = ""
          expect {
            xhr :post, :create, params 
          }.to_not change(Post, :count)
          response.should render_template("new")
        end

        it "does nto create a question if it does not have a content" do
          params['question']['content'] = ""
          expect {
            xhr :post, :create, params 
          }.to_not change(Post, :count)
          response.should render_template("new")
        end
        
        it "does not create a question if it does not have tags" do
          params['question']['tag_list'] = ""
          expect {
            xhr :post, :create, params
          }.to_not change(Post, :count)
          response.should render_template("new")
        end
      end

      describe "while user is not signed in" do
        it "does not create a question if a user is not signed in" do
          expect {
            xhr :post, :create, params 
          }.to_not change(Post, :count)
          response.status.should eq 401 #unauthorized access
        end
      end
    end
  end

  describe 'show' do
    it 'goes to show' do
      question = FactoryGirl.create(:question)
      xhr :get, :show, :id => question.id 
      response.should be_success
    end 
  end

  describe "update" do
    before(:each) do
      @post = FactoryGirl.create(:question)
      @post_key = :question
    end

    
    describe "a user answered the question" do
      before(:each) do
        @post_of_post_attributes_key = :answers_attributes
      end
    
      it_behaves_like "a user posted on a post"
    end

    describe "a user commented" do
      before(:each) do
        @post_of_post_attributes_key = :comments_attributes
      end
  
      it_behaves_like "a user posted on a post"
    end   
  end
end

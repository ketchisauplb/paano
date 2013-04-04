class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def create 
    @question = User.find(current_user.id).questions.new(params[:question])
    if @question.save
      redirect_to :questions
    else
      render :new      
    end 
  end

  def new
    @question = Question.new
  end

  def show

  end

end

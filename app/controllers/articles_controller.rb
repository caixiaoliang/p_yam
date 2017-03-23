class ArticlesController < ApplicationController

  # before_filter :login


  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.original_author_id = current_user.id
    if @article.save
      redirect_to article_path(@article)
    else
      binding.pry
      render "new"
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
  end


  private
    def article_params
      params.require(:article).permit(:title, :content)
    end
end

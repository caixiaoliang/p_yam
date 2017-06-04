class ArticlesController < ApplicationController

  # before_filter :login


  def index 
    @articles = current_user.articles
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.original_author_id = current_user.id
    @article.user_id = current_user.id
    if @article.save
      redirect_to article_path(@article)
    else
      render "new"
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if params[:autosave] == "1"
      @article.published = false
      @article.assign_attributes(article_params)
      if @article.save
        render json: {success: true,msg: "自动保存成功"}
      else
        render jsn: {success: false,msg: "自动保存失败"}
      end
    else
      if @article.update_attributes(article_params)
        redirect_to article_path(@article)
      else
        render "edit"
      end
    end
  end


  private
    def article_params
      params.require(:article).permit(:title, :content)
    end
end

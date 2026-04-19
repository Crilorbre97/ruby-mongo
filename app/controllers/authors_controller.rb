class AuthorsController < ApplicationController
  def index
    @authors = Author.all
    render json: @authors
  end

  def show
    @author = Author.find(params[:id])
    render json: @author
  end

  def create
    @author = Author.create(author_params)
    if @author.save
      render json: @author, status: :created
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def update
    @author = Author.find(params[:id])
    if @author.update(author_params)
      render json: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    render json: { message: "Author with #{params[:id]} has been deleted" }, status: :ok
  end

  private

  def author_params
    params.require(:author).permit(:name, :lastname, :email, :city, :birth_date)
  end
end

class BooksController < ApplicationController
 before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
     flash[:notice] ='You have created book successfully.'
     redirect_to book_path(@book)
    else
      @user = current_user
      @books = current_user.books
      render 'users/show'
    end
  end

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def edit
    @book = Book.find(params[:id])
  end


  def update
    @book = Book.find(params[:id])
    @book.update(book_params)
    flash[:notice] = 'You have updated book successfully.'
    redirect_to book_path(@book.id)
  end

 private
  def book_params
    params.require(:book).permit(:title, :opinion)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end
  
end

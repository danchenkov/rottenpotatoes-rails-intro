class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID


  end

  def index
    @order = params[:order]
    @all_ratings = Movie.all_ratings
    unless params[:ratings]
      @ratings = session[:ratings] || @all_ratings
      flash.keep
      redirect_to movies_path(order: @order, ratings: @ratings)
    end
    @ratings = params[:ratings]
    session[:ratings] = @ratings
    @movies = case params[:order]
    when 'date'
      Movie.where(rating: @ratings.to_a).order(:release_date)
    when 'title'
      Movie.where(rating: @ratings.to_a).order(:title)
    when 'rating'
      Movie.where(rating: @ratings.to_a).order(:rating)
    else
      Movie.where(rating: @ratings.to_a)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #*
    # The redirection variables at rating hash
    r_key = nil
    r_ratings = nil
    redirect = nil
    @all_ratings = Movie.all_ratings

    #*
    # If there is valid session variables saved, redirect with them
    if ((session[:key] == "title" || session[:key] == "release_date") && !session[:rating].nil?)
	redirect = true
	r_key = session[:key]
	r_ratings = session[:ratings]
    end   
 
    #*
    # Set the correct sorting key and css class
    if params[:key] == "title"
	@title_class = "hilite"
        @rd_class = nil
	r_key = params[:key]
	session[:key] = params[:key]
    elsif params[:key] == "release_date"
	@title_class = nil
	@rd_class = "hilite"
	r_key = params[:key]
	session[:key] = params[:key]
    end

    #*
    # Set the correct rating filter
    if !params[:ratings].nil?
	session[:ratings] = params[:ratings]
	@filter = params[:ratings].keys
    else
	session[:ratings] = params[:ratings]
	@filter = @all_ratings
    end

    #*
    # Now return the filtered, sorted movie list
    @movies = Movie.find_all_by_rating(@filter, :order=>"#{params[:key]}")

    #*
    # If there were valid session variables, redirect
    # back to this function using those
    if redirect == true
	flash.keep
	redirect_to :action=>'index', :key=>r_key, :ratings=>r_ratings
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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

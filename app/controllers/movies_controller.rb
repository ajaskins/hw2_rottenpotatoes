class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #create all the ratings from the movies available
    @ratings_form = Movie.ratings_form
    #assume we don't need to redirect until proven otherwise
    redirect = false

    #update the ordering of the columns, and check for redirection need from columns being ordered
    #in the current window something is ordered, save the change, but no need to change display
#    if params[:order_by]
#        @order_by = params[:order_by]
#        session[:organize_by] = params[:order_by]
    #one of the columns in previous section are ordered, therefore redirection is needed
#    elsif session[:order_by]
#        @order_by = session[:order_by]
#        redirect = true 
    #no columns are/were sorted, keep that way
#    else
#        @order_by = nil
#    end
    
    #keeps track of ratings filter, and checks for redirection need from one or more ratings being selected
    #if there is no checked boxes but the refresh button is selected, then send all the movies since not filtering anything
    if params[:ratings].nil? and params[:commit] == "Refresh"
        @ratings = nil
        session[:ratings] = nil
    #if a ratings box is currently checked, give that set of ratings to view, and store for redirection checks
    elsif params[:ratings]
        @ratings = params[:ratings]
        session[:ratings] = params[:ratings]
    #if there was a ratings filter on the prior view, then a redirection is needed to return to same list
    elsif session[:ratings]
        @ratings = session[:ratings]
        redirect = true
    #no rating selected, keep it that way
    else
        @ratings = nil
    end

    #Need to return to a sorted page instead of main page
    if redirect
        flash.keep
        redirect_to movies_path :organize_by=>@order_by, :ratings=>@ratings
    end

    #assigns movies the approprate list so correct subset/order are shown
    #if rating, and column selected
    if @ratings and @order_by
        @movies = Movie.where(:rating => @ratings.keys).find(:all, :order => (@order_by))
    #if just a rating is selected
    elsif @ratings
        @movies = Movie.where(:rating => @ratings.keys)
    #if just a column is selected
    elsif @order_by
        @movies = Movie.find(:all, :order => (@order_by))
    #if no sort is selected
    else
        @movies = Movie.all
    end

    #if there is nothing in rating, make it a hash of the ratings
    if !@ratings
        @ratings = Hash.new
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

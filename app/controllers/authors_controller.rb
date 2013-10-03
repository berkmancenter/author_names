class AuthorsController < ApplicationController
  def index
    @authors = Author.paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @author = Author.new
  end
  
  def edit
    @author = Author.find(params[:id])
  end
  
  def create
    @author = Author.new(params[:author])
    respond_to do |format|
      if @author.save
        format.html { redirect_to authors_url, notice: 'Author was successfully created.' }
        format.json { render json: @author, status: :created, author: @author }
      else
        format.html { render action: "new" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @author = Author.find(params[:id])

    respond_to do |format|
      if @author.update_attributes(params[:author])
        format.html { redirect_to authors_url, notice: 'Author was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @author = Author.find(params[:id])
    @author.destroy

    respond_to do |format|
      format.html { redirect_to authors_url }
      format.json { head :no_content }
    end
  end
end

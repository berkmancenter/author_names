class LibrariesController < ApplicationController
  before_filter :authenticate_superadmin!, :except => [:show, :edit, :update]
  
  def index
    @libraries = Library.all
  end
  
  def new
    @library = Library.new
  end
  
  def edit
    @library = Library.find(params[:id])
  end
  
  def create
    @library = Library.new(params[:library])
    respond_to do |format|
      if @library.save
        format.html { redirect_to libraries_url, notice: 'Library was successfully created.' }
        format.json { render json: @library, status: :created, library: @library }
      else
        format.html { render action: "new" }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @library = Library.find(params[:id])

    respond_to do |format|
      if @library.update_attributes(params[:library])
        format.html { redirect_to edit_library_url(@library), notice: 'Library was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @library = Library.find(params[:id])
    library = @library.name
    @library.destroy

    respond_to do |format|
      format.html { redirect_to libraries_url, notice: "#{library} was successfully deleted." }
      format.json { head :no_content }
    end
  end  
end

class PublishersController < ApplicationController
  before_filter :authenticate_superadmin!, :except => [:show, :edit, :update]
  
  def index
    @publishers = Publisher.all
  end
  
  def new
    @publisher = Publisher.new
  end
  
  def edit
    @publisher = Publisher.find(params[:id])
  end
  
  def create
    @publisher = Publisher.new(params[:publisher])
    respond_to do |format|
      if @publisher.save
        format.html { redirect_to publishers_url, notice: 'Publisher was successfully created.' }
        format.json { render json: @publisher, status: :created, publisher: @publisher }
      else
        format.html { render action: "new" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        format.html { redirect_to edit_publisher_url(@publisher), notice: 'Publisher was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @publisher = Publisher.find(params[:id])
    publisher = @publisher.name
    @publisher.destroy

    respond_to do |format|
      format.html { redirect_to publishers_url, notice: "#{publisher} was successfully deleted." }
      format.json { head :no_content }
    end
  end
end

class ProgramCategoriesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @program_category_pages, @program_categories = paginate :program_categories, :per_page => 10
  end

  def show
    @program_category = ProgramCategory.find(params[:id])
  end

  def new
    @program_category = ProgramCategory.new
  end

  def create
    @program_category = ProgramCategory.new(params[:program_category])
    if @program_category.save
      flash[:notice] = 'ProgramCategory was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @program_category = ProgramCategory.find(params[:id])
  end

  def update
    @program_category = ProgramCategory.find(params[:id])
    if @program_category.update_attributes(params[:program_category])
      flash[:notice] = 'ProgramCategory was successfully updated.'
      redirect_to :action => 'show', :id => @program_category
    else
      render :action => 'edit'
    end
  end

  def destroy
    ProgramCategory.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

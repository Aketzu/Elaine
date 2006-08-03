class ProgramDescriptionsController < ApplicationController
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @program_descriptions_pages, @program_descriptions = paginate :program_descriptions, :per_page => 10
  end

  def show
    @program_descriptions = ProgramDescription.find(params[:id])
  end

  def new
    @program_descriptions = ProgramDescription.new
  end

  def create
    @program_descriptions = ProgramDescription.new(params[:program_descriptions])
    if @program_descriptions.save
      flash[:notice] = 'ProgramDescription was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @program_descriptions = ProgramDescription.find(params[:id])
  end

  def update
    @program_descriptions = ProgramDescription.find(params[:id])
    if @program_descriptions.update_attributes(params[:program_descriptions])
      flash[:notice] = 'ProgramDescription was successfully updated.'
      redirect_to :action => 'show', :id => @program_descriptions
    else
      render :action => 'edit'
    end
  end

  def destroy
    ProgramDescription.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

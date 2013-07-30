require 'fastercsv'

class RunlistsController < ApplicationController
	require_permission REPORTER

  # GET /Runlists
  # GET /Runlists.xml
  def index
    @runlists = Runlist.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @runlists }
    end
  end

  # GET /Runlists/1
  # GET /Runlists/1.xml
  def show
    @runlist = Runlist.find(params[:id])
		(rend; return) if request.xhr?

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @runlist }
    end
  end

  # GET /Runlists/new
  # GET /Runlists/new.xml
  def new
    @runlist = Runlist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @runlist }
    end
  end

  def savecsv
    return unless params[:runlist]
    @program = Program.find(params[:runlist][:program_id])
    return unless @program

    redirect_to edit_program_path(@program)

    return unless params[:runlist][:runlistcsv]
    
    hdr = []

    @program.runlists = {}
    @program.save

    cc=0
    FasterCSV.foreach(params[:runlist][:runlistcsv].path, :col_sep => ';', :quote_char => '"') { |rr|
      if hdr.empty?
        hdr = rr
        next
      end

      cc=cc+1

      rl = Runlist.new(:program_id => @program.id, :position => cc)
      

      (0..hdr.length).each {|c|

        rl.video = rr[c] if hdr[c] =~ /^video/i
        rl.audio = rr[c] if hdr[c] =~ /^audio/i
        rl.content = rr[c] if hdr[c] =~ /^content/i
        rl.info = rr[c] if hdr[c] =~ /^notes/i
        rl.formatted_length = rr[c] if hdr[c] =~ /^length/i and rr[c]
        rl.tg = rr[c] if hdr[c] =~ /^tg/i
      }
      rl.content ||= ""

      rl.save unless rl.content.empty?
    }

  end

  # GET /Runlists/1/edit
  def edit
    @runlist = Runlist.find(params[:id])
		(rend; return) if request.xhr?
  end

  # POST /Runlists
  # POST /Runlists.xml
  def create
    @runlist = Runlist.new(params[:runlist])


    respond_to do |format|
      if @runlist.save
				(rend; return) if request.xhr?
        flash[:notice] = 'Runlist was successfully created.'
        format.html { redirect_to(@runlist) }
        format.xml  { render :xml => @runlist, :status => :created, :location => @runlist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @runlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /Runlists/1
  # PUT /Runlists/1.xml
  def update
    @runlist = Runlist.find(params[:id])

    respond_to do |format|
      if @runlist.update_attributes(params[:runlist])
				(rend; return) if request.xhr?
        flash[:notice] = 'Runlist was successfully updated.'
        format.html { redirect_to(@runlist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @runlist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /Runlists/1
  # DELETE /Runlists/1.xml
  def destroy
    @runlist = Runlist.find(params[:id])
    @runlist.destroy
		
		(rend; return) if request.xhr?

    respond_to do |format|
      format.html { redirect_to(runlists_url) }
      format.xml  { head :ok }
    end
  end

	def up
		@runlist = Runlist.find(params[:id])
		@runlist.move_higher

		(rend; return) if request.xhr?
	end

	def down
		@runlist = Runlist.find(params[:id])
		@runlist.move_lower

		(rend; return) if request.xhr?
	end

	def rend
		@rl = Runlist.new
		@rl.program = @runlist.program
		list = @runlist.program.runlists

		@rl = @runlist if params[:action] == 'edit'

		render :partial => 'programs/runlist', :object => list
	end
end

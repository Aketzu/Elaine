require 'csv'
class ProgramsController < ApplicationController
	require_permission REPORTER

	def buildsearch
    @search = "1=1 "
    @searchparams = Hash.new

    if params[:find_by_user] && params[:find_by_user] != "0"
      @user = User.find(params[:find_by_user])
      @user = @user.id unless @user.nil?
      @search += " AND programs.owner_id = :owner_id "
      @searchparams[:owner_id] = @user
    end

    if params[:find_by_category] && params[:find_by_category] != "0"
      @category = ProgramCategory.find(params[:find_by_category])
      @category = @category.id unless @category.nil?
      @search += " AND programs.program_category_id = :category_id "
      @searchparams[:category_id] = @category
    end

    @filter ||= params[:search]
    @filter ||= params[:desc] unless params[:desc].nil?
    @filter ||= ""

    unless @filter.empty?
      # TODO: ILIKE is Postgres specific, but is there another way?

      #Creates funny effects with multilanguage titles (i.e. same
      # programs appear with different titles depending on search
      # keywords == shows title in the language where keyword was found)
      #Fixing would require either dropping :include =>
      # :program_descriptions or additional SQL query in Program.title
      @search += " AND program_descriptions.title LIKE :title "
      @searchparams[:title] = "%#{@filter}%"
    end

    unless params[:ignore_date_filter] && params[:ignore_date_filter] != 'false'
      @search += " AND programs.created_at > :created_at "
      @searchparams[:created_at] = @date_filter = CONTENT_FILTER
    end

  end


  # GET /programs
  # GET /programs.xml
  def index
		@user ||= 0
		@category ||= 0

		buildsearch
    sort = case params[:sort]
      when 'title'; 'program_descriptions.title'
      #when 'length'; 'length'
      when 'target'; 'target_length'
      when 'created'; 'programs.created_at'
      when 'modified'; 'programs.updated_at'
      when 'owner'; 'users.login'
      when 'status'; 'program_statuses.name'
      when 'vod'; 'do_vod'
      when 'minshow'; 'min_show'
      when 'maxshow'; 'max_show'
      when 'quarantine'; 'quarantine'
      else 'programs.created_at'
    end
    order = case params[:order]
      when 'asc'; 'asc'
      when 'desc'; 'desc'
      else ''
    end

    sort += " " + order
    sort += ', program_descriptions.lang'


    @programs = Program.roots.paginate \
			:page => params[:page], 
			:order => sort, 
			:include => [:program_descriptions, :program_category, :owner, {:children => [:program_descriptions]}],
			:conditions => [@search, @searchparams]


    respond_to do |format|
      format.html {
					render :partial => "list" if request.xhr?
			}
      format.xml  { render :xml => @programs }
    end
  end

  def all
    @programs = Program.all(:include => [:program_descriptions, :owner, :children, :playlists, :program_category], :order => "program_category_id asc, created_at")

    respond_to do |format|
      format.html {
					render :partial => "list" if request.xhr?
			}
      format.xml  { render :xml => @programs }
    end

  end

  # GET /programs/1
  # GET /programs/1.xml
  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program }
    end
  end


	def import 
		@party = "asm12"
		pms = Pms.new
		@compos = pms.compos(@party).parsed_response

    respond_to do |format|
      format.html # show.html.erb
    end
	end

	def doimport
		@party = "asm12"
		@compo = params[:id]

		pms = Pms.new
		return if params[:id].nil?

		@entries = pms.entries(@party, @compo).parsed_response
		@entries ||= []

    quarantine = Time.local(params[:date][:year], params[:date][:month], params[:date][:day], params[:date][:hour], params[:date][:minute], params[:date][:second])  if params[:doit]

		parent = Program.find_by_pms_path(@party + "/" + @compo)
		if !parent and params[:doit]
			parent = Program.new
			parent.owner = current_user
			parent.program_descriptions << ProgramDescription.Defaults
			parent.program_descriptions.each { |pd|
				pd.title = @party + "/" + @compo
			}
			parent.pms_path = @party + "/" + @compo
			parent.program_category_id = 21
			parent.do_vod = false
			parent.programtype = "Insert"
			parent.status = "Production"
			parent.quarantine = quarantine
			parent.filename = parent.title.scan(/./).map { |ch| ch.gsub(/ /, '_').gsub(/[^A-Za-z0-9_]/,'')  }.flatten.join("")
			parent.save!
		end


		events = Array.new
		eevents = Array.new

		@entries.each { |e|
			if params[:doit] then
				ee = Program.find_by_pms_path(@party + "/" + @compo + "/" + e["id"].to_s)
				ee = Program.new if ee.nil?

				ee.pms_path = @party + "/" + @compo + "/" + e["id"].to_s
				title = e["name"]
				title += " by " + e["credits"] unless e["credits"].empty?
				ee.owner = current_user
				ee.program_descriptions << ProgramDescription.Defaults
				ee.program_descriptions.each { |pd|
					pd.title = title
				}
				ee.program_category_id = 21
				ee.do_vod = true

				ee.target_length = 60 if ee.target_length.nil?
				ee.programtype = "Insert"
				ee.status = "Production"
				ee.filename = ee.title.scan(/./).map { |ch| ch.gsub(/ /, '_').gsub(/[^A-Za-z0-9_]/,'')  }.flatten.join("")
				ee.quarantine = quarantine
				ee.program_id = parent.id
				ee.save!
				eevents << ee
			end
		}

		if params[:doit] then
			parent.children = eevents
			parent.save!
		end

		render :action => 'import'
	end


  # GET /programs/new
  # GET /programs/new.xml
  def new
    @program = Program.new
		@program.owner = current_user
		@program.program_descriptions << ProgramDescription.Defaults
		@program.program_category_id = (cookies[:progcategory] || DEFAULT_CATEGORY).to_i

		@program.mcu_auxout = "PGM";
		@program.mcu_auxres = "1080i50";

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program }
    end
  end

  # GET /programs/1/edit
  def edit
    @program = Program.find(params[:id])
		@rl = Runlist.new
		@rl.program = @program
  end

	def print
		@program = Program.find(params[:id])
	end

  # POST /programs
  # POST /programs.xml
  def create
    @program = Program.new(params[:program])
    @program.vod_status = 0

		params[:program_description].each { |id, pdata|
			pd = ProgramDescription.new(pdata)
			@program.program_descriptions << pd
		}
		expire_page :controller => :programs, :action => :vods	
		
		cookies[:progcategory] = @program.program_category_id.to_s

    respond_to do |format|
      if @program.save
        flash[:notice] = 'Program was successfully created.'
        format.html { redirect_to(programs_path) }
        format.xml  { render :xml => @program, :status => :created, :location => @program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /programs/1
  # PUT /programs/1.xml
  def update
    @program = Program.find(params[:id])
		expire_page :controller => :programs, :action => :vods	
		cookies[:progcategory] = @program.program_category_id.to_s

		params[:program_description].each { |id, pdata|
			pd = ProgramDescription.find(id)
			unless pd.update_attributes(pdata)
				flash[:notice] = 'Program description update failed.'
				render :action => "edit"
				return
			end
		}

    respond_to do |format|
      if @program.update_attributes(params[:program])
        flash[:notice] = 'Program was successfully updated.'
        format.html { redirect_to(programs_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.xml
  def destroy
    @program = Program.find(params[:id])
		parent = Program.find(params[:parent]) if params[:parent]
    @program.destroy

		if request.xhr?
			if params["src"] == "subprograms"
				@program = parent
				render :partial => "subprograms", :object => @program.children
				return
			else
				index
			end
			return
		end

    respond_to do |format|
      format.html { redirect_to(programs_url) }
      format.xml  { head :ok }
    end
  end

	skip_before_filter :verify_authenticity_token, :only => [:autocomplete, :update_files]

	def autocomplete
		@key = "subprog_id" unless params[:subprog].nil?
		@key = "playlist_program_id" unless params[:playlist].nil?
		data = params[:subprog]
		data ||= params[:playlist][:program]
		@programdesc = ProgramDescription.find(:all, :conditions => ['(title LIKE :q OR description LIKE :q)', {:q => "%#{data}%"}], :order => :title, :limit => 50, :include => :program)
		@programdesc.sort!{|a,b| b.program.created_at.year == a.program.created_at.year ? a.title <=> b.title : b.program.created_at.year <=> a.program.created_at.year}
		render :inline => '<%= content_tag("ul", @programdesc.map { |pd| content_tag("li", "[#{pd.program.created_at.year}] #{pd.title}", "id" => "#{@key}::#{pd.program_id}") }.uniq) %>'
	end


	def link
    @program = Program.find(params[:id])
		@subprog = Program.find(params[:subprog_id])
		@program.children << @subprog
		flash[:error] = 'Error linking program' unless @program.save!
		render :partial => "subprograms", :object => @program.children if request.xhr?

	end

	def unlink
		@link = ProgramsProgram.find(:first, :conditions => { :program_id => params[:id], :subprogram_id => params[:subprog_id]})
		@link.remove_from_list
		flash[:error] = 'Error unlinking program' unless ProgramsProgram.delete @link
		@program = Program.find(params[:id])
		(index; return) if params["src"] == "programs"
		render :partial => "subprograms", :object => @program.children if request.xhr?
	end
	
	def move
		@link = ProgramsProgram.find(:first, :conditions => { :program_id => params[:id], :subprogram_id => params[:subprog_id]})
		@link.move_higher if params[:dir] == "up"
		@link.move_lower if params[:dir] == "down"
		@program = Program.find(params[:id])
		(index; return) if params["src"] == "programs"
		render :partial => "subprograms", :object => @program.children if request.xhr?
	end
	
	caches_page :vods
	skip_before_filter :login_required, :only => [:vods, :update_files, :nextvod, :voddone, :published, :vodlist]
	skip_before_filter :check_auth, :only => [:vods, :update_files, :nextvod, :voddone, :published, :vodlist]
	def vods
		if params[:id]
			pids = Vod.find(:all, :group => :program_id, :conditions => ["created_at > '#{params[:id]}-01-01'"]).map { |v| v.program_id }
		else 
			pids = Vod.find(:all, :group => :program_id).map { |v| v.program_id }
		end
		@programs = Program.find(:all, :include => [{:vods => :vod_format}, :program_descriptions, :program_category], :conditions => ["id in (?) AND quarantine < now()", pids])
    respond_to do |format|
      format.xml 
    end
	end
	
	def published
		@programs = Program.find(:all, :conditions => ["quarantine < now() AND do_vod"])
		render :text => ";" + @programs.map{|p| p.id}.sort.join(";") + ";";
	end

	def vodlist
		@programs = Program.find(:all, :conditions => 'pms_path is not null')

		render :text => @programs.map{|p| p.id.to_s + ":" + p.pms_path }.sort.join("\n") 
	end

	def update_files
		return if request.raw_post.nil?

		Program.transaction do 
			request.raw_post.each { |f|
				match = f.match(/.*\/([0-9]*)_(.*)\.([a-z]*)$/)
				next unless match

				obj = nil

				begin
					obj = Program.find(match[1])
				rescue
					next
				end

        if obj.nil? then
          logger.info "Couldn't find object for " + match[0]
          next
        end

        #if obj.filename != match[3] then
        #  logger.info "Filename mismatch " + obj.filename + " vs. " + match[0]
        #  next
        #end

				obj.filename = match[2] + "." + match[3];
        obj.file_exists = true
        obj.file_status_updated = Time.now

        obj.vod_status = 1 if obj.vod_status.to_i < 1
        obj.save!
			}
		end
		render :text => "Done"
	end

	def nextvod
		#prog = Program.to_vod.find(:all, :include => [:vods], :conditions => ["file_resy is null"])
    vs = 1
    vs = params[:status].to_i if params[:status] != ""

    prog = Program.find(:all, :include => [:vods], :conditions => ["vod_status = " + vs.to_s])
		prog.each { |p|
			#next unless p.vods.count == 0
			result = Array.new

			result << "VOD"
			result << p.id
			result << p.preview_image_offset
			result << p.filename.gsub(/\.[A-Za-z0-9]*$/, "").gsub(/ /, "_")
			result << p.full_filename
			result << p.program_category.name

			#Hack
			#p.file_resy = 0;
      p.vod_status = vs+1
			p.save!

			render :text => result.join("|")
			return
		}
		render :text => "nada"

	end

	def voddone
		prog = Program.find(params[:progid])

    prog.vod_status = 3
    prog.save

		vod = Vod.find_by_filename(params[:filename])
		vod ||= Vod.new
		vod.program = prog
		vod.filename = params[:filename]
		vod.filesize = params[:size]
		vod.length = params[:length]
		vod.vod_format = VodFormat.find_by_name("2009_" + params[:format])

		vod.save!
		expire_page :controller => :programs, :action => :vods, :id => 2009, :format => :xml

		render :text => "OK"
	end

	def update_status
		prog = Program.find(params[:progid])

    prog.vod_status = params[:status]
    prog.save

		render :text => "OK"
	end

  def runlistcsv
		prog = Program.find(params[:id])
    #csvs = CSV.generate { |csv|
    csvs=""
    CSV.generate_row(["Pos", "Video", "Audio", "Content", "Notes", "Length", "Total", "TG"], 8, csvs)
    totlen=0
    prog.runlists.each { |p|
      totlen += p.length if p.length
      CSV.generate_row([p.position, p.video, p.audio, p.content, p.info, format_length(p.length), format_length(totlen), p.tg], 8, csvs)
    }
    response.content_type = Mime::CSV
    headers["Content-Disposition"] = "attachment; filename=\"prog_"+prog.id.to_s+".csv\""
    render :text => csvs

  end

end

class FlashinfosController < ApplicationController
	skip_before_filter :login_required, :only => [:data]
  skip_before_filter :check_auth, :only => [:data]

  # GET /flashinfos
  # GET /flashinfos.xml
  def index
		@infos = Hash.new
    Flashinfo.find(:all).each { |ff|
			@infos[ff.key] = ff.value
		}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @flashinfos }
    end
  end

	def data
		@infos = Hash.new
    Flashinfo.find(:all).each { |ff|
			@infos[ff.key] = ff.value
		}

		channel = DEFAULT_CHANNEL
		
		@current = Playlist.for_channel(channel).find(:all,
				:conditions => ["start_at <= now() and programs.hidden = false"],
				:include => [:program => [:children, :program_descriptions]],
				:order => "start_at desc",
				:limit => 1).first

		@playlists = Playlist.for_channel(channel).find(:all,
				:conditions => ["start_at > now() and programs.hidden = false"],
				:include => [:program => [:children, :program_descriptions]],
				:order => :start_at,
				:limit => 10)
		while @playlists.length < 10
			@playlists << Playlist.new
		end
		respond_to do |format|
		format.xml  { render :xml => @playlist }
		end

	end

  def save
		infos = Hash.new
    Flashinfo.find(:all).each { |ff|
			infos[ff.key] = ff
		}
		params.each { |k,v|
			next if ["commit", "authenticity_token", "action", "controller"].include? k
			logger.debug k + " = " + v
			infos[k] = Flashinfo.new(:key => k, :value => v) unless infos[k] 

			infos[k].value = v
			infos[k].save
		}

		flash[:notice] = "Settings saved"
		redirect_to(flashinfos_path)
  end

end

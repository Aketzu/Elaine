class VodController < ApplicationController
  skip_before_filter :login_required

  def next
		program_ids = Program.find_by_sql "SELECT
				p.id as program_id,
				vgf.video_format_id as video_format_id
			FROM programs p
			INNER JOIN program_categories pc ON p.program_category_id = pc.id
			INNER JOIN vod_groups vg ON pc.vod_group_id = vg.id
			INNER JOIN vod_group_format_links vgf ON vgf.vod_group_id = vg.id
			WHERE p.file_exists
			
			EXCEPT

			SELECT
			 program_id,
			 video_format_id
			FROM vods v
			"


		for results in program_ids 
			program = Program.find(results[:program_id])
#     if program.file_exists? or RAILS_ENV == "development" # TODO: dev environment should have working file locations?
			# We have a winner
			@program = program
			@vod_format = VideoFormat.find(results[:video_format_id])
			# TODO: We assume a location with the name of the vod group exists. This should be mapped in the DB.
			vod_location = FileLocation.find(:first, :conditions => ["name = ?", program.ProgramCategory.VodGroup.name]);
			if vod_location.nil?
				@result = 'File location "' + program.ProgramCategory.VodGroup.name + '" missing'
				render :text => @result
				return
			end
			Vod.transaction do
				@vod = Vod.new(:filename => program.filename + '_' + @vod_format.vcodec + '_' + @vod_format.vbitrate.to_s + 'kbps',
											 :file_location_id => vod_location.id,
											 :video_format_id => @vod_format.id,
											 :completed => 'false',
											 :program_id => program.id);
				if @vod.save
					result = Array.new
					result << "VOD"
					result << @vod.id
					result << @vod_format.name

					image_offset = @program.preview_image_offset || 30
					if image_offset > @program.length 
						image_offset = @program.length
					end
					result << image_offset
					video_offset = @program.preview_video_offset || 0
					if video_offset > @program.length - 30
						video_offset = @program.length - 30
					end 
					if video_offset < 0
						video_offset = 0
					end  
					result << video_offset
					result << @vod.preview_base_filename
					result << @vod.base_filename
					result << @program.full_filename

					render :text => result.join("|")
					return
				else
					@result = "Could not save vod!"
					render :text => @result
					return
				end
			end
#          end
		end
    # Found nothing
    @program = nil
    @vod_format = nil

		render :text => "Nothing to do"
  end
  
  def completed
    vod = Vod.find(params[:id])
    vod.completed = 'true'
    vod.length = params[:length]
    vod.filesize = params[:size]
    if vod.save
      @message = 'OK'
    else
      @message = 'save failed'
    end
    rescue
      @message = 'invalid vod id'
  end

  def error
     @message = params[:message]
  end
end

class VodController < ApplicationController
  skip_before_filter :authorize_action

  before_filter :require_no_ssl if (RAILS_ENV == "production")
  
  def next  
    #Efficiency note: We assume that is usually |VodFormats| << |Programs| 
#    VodFormat.find(:all).each do |format|
#      format.VodGroups.each do |group|
#        program = group.Programs.find(:first, 
#                                      :conditions => ["do_vod = true AND (SELECT COUNT(*) FROM vods WHERE vods.program_id = programs.id AND vods.vod_format_id = ?) = 0", format.id],
#                                      :order => "programs.vod_group_id DESC") # TODO: A hack to give compos priority, should have acts as list
# example: Post.find_by_sql "SELECT p.*, c.author FROM posts p, comments c WHERE p.id = c.post_id"
        program_ids = Program.find_by_sql "SELECT programs.id as program_id, MIN(vod_format_id) FROM programs JOIN vod_groups ON programs.vod_group_id = vod_groups.id JOIN vod_group_format_links ON vod_groups.id = vod_group_format_links.vod_group_id WHERE vod_format_id NOT IN (SELECT vod_format_id FROM programs JOIN vods ON programs.id = vods.program_id) AND programs.do_vod = true ORDER BY programs.vod_group_id DESC GROUP BY program_id;"
        
        for results in program_ids 
          program = Program.find(results[:program_id])
 #         if !program.nil?
          if program.file_exists? or RAILS_ENV == "development" # TODO: dev environment should have working file locations?
            # We have a winner
            @program = program
            @vod_format = VodFormat.find(results[:vod_format_id])
            # TODO: We assume a location with the name of the vod group exists. This should be mapped in the DB.
            vod_location = FileLocation.find(:first, :conditions => ["name = ?", program.VodGroup.name]);
            if vod_location.nil?
              redirect_to :action => 'error', :message => 'File location "' + program.VodGroup.name + '" missing'
              return
            end
            @vod = Vod.new(:filename => program.filename + '_' + @vod_format.vcodec + '_' + @vod_format.vbitrate.to_s + 'kbps',
                           :file_location_id => vod_location.id,
                           :vod_format_id => @vod_format.id,
                           :completed => 'false',
                           :program_id => program.id);
            if @vod.save
              return
            else
              redirect_to :action => 'error', :message => 'could not save vod'
              return
            end
          end
        end
     # end
    #end 
    # Found nothing
    @program = nil
    @vod_format = nil
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

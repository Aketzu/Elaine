class VodController < ApplicationController
  skip_before_filter :authorize_action

  before_filter :require_no_ssl if (RAILS_ENV == "production")
  
  def next
    # TODO: We assume a location with the name vod exists. This is a nasty hack.
    vod_location = FileLocation.find(:first, :conditions => "name = 'vod'");
    if vod_location.nil?
      redirect_to :action => 'error', :message => 'vod location missing'
      return
    end
  
    #Efficiency note: We assume that is usually |VodFormats| << |Programs| 
    VodFormat.find(:all).each do |format|
      format.VodGroups.each do |group|
        program = group.Programs.find(:first, :conditions => ["(SELECT COUNT(*) FROM vods WHERE vods.program_id = programs.id AND vod_format_id = ?) = 0", format.id])
        unless program.nil?
#          if program.file_exists? 
             # We have a winner
             @program = program
             @vod_format = format
             @vod = Vod.new(:filename => program.filename + '_' + format.vbitrate.to_s + '_kbps',
                            :file_location_id => vod_location.id,
                            :vod_format_id => format.id,
                            :completed => 'false',
                            :program_id => program.id);
             if @vod.save
               return
             else
              redirect_to :action => 'error', :message => 'could not save vod'
              return
             end
#          end
        end
      end
    end 
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

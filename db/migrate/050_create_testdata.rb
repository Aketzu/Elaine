# Please fill some test data here that is of good quality and
# not some 'liirum laarum lorem ipsum' you come up with.
# Test data's purpose is to function as somewhat sensible
# real life simulation.
class CreateTestdata < ActiveRecord::Migration
  def self.up
    Channel.create(
    :name => 'Testikanava',
    :description => %{ Poista tämä kun siirrytään tuotantoon. })
#     BroadcastLog.create(
#     :time                 => '01-01-06 12:00', 
#     :program_id           => 1,
#     :channel_id           => 1)

#      FileLocation.create(
#     :name                 => '',
#     :description          => '',
#     :url                  => '')
     FileLocation.create(
    :name                 => 'Location 1',
    :description          => 'Descripting file location',
    :url                  => 'file://siilo/paikka',
    :checker_url          => 'http://mesta')
    

#    VodFormat.create(    
#       :name => '',
#       :description => '',
#       :vcodec => '',
#       :acodec => '',    
#       :container => '',
#       :vbitrate =>  '',
#       :abitrate =>  '',
#       :width  =>  '',
#       :height   =>  '')

    VodFormat.create(    
       :name => 'lowest',
       :description => 'very low bitrate',
       :vcodec => 'x264',
       :acodec => 'mp3lame',    
       :container => 'avi',
       :vbitrate =>  '208',
       :abitrate =>  '48',
       :width  =>  '720',
       :height   =>  '576',
       :framerate => '15')


#      VodGroup.create(
#     :name                 => '',
#     :description          => '')

      VodGroup.create(
     :name                 => 'Test group',
     :description          => 'Vod group for testing')

#     VodGroupFormatLink.create(
#     :vod_group_id           => '',
#     :vod_format_id             => '')

     VodGroupFormatLink.create(
     :vod_group_id           => '1',
     :vod_format_id             => '1')


#     Event.create(
#     :title                => '',
#     :script               => '',
#     :location_id          => '',
#     :event_type_id        => '',
#     :notes                => '',
#     :length               => '',
#     :quarantine           => '',
#     :created_at           => '',
#     :updated_at           => '')

    Event.create(
    :title                => 'Event 1',
    :script               => 'Script 753',
    :location_id          => 1,
    :event_type_id        => 1,
    :notes                => 'Notes',
    :length               => 1020,
    :quarantine           => 'Aug 3 2006 15:30:00 GMT',
    :created_at           => 'July 16 2006 17:37:10 GMT',
    :updated_at           => 'July 16 2006 18:52:10 GMT',
    :file_location_id     => 1,
    :filename             => 'filename_event_1')
    Event.create(
    :title                => 'Event 2',
    :script               => 'Script 534',
    :location_id          => 1,
    :event_type_id        => 1,
    :notes                => 'Notes',
    :length               => 810,
    :quarantine           => 'Aug 3 2006 15:30:00 GMT',
    :created_at           => 'July 16 2006 17:37:20 GMT',
    :updated_at           => 'July 16 2006 18:52:20 GMT',
    :file_location_id     => 1,
    :filename             => 'filename_event_2')
    Event.create(
    :title                => 'Event 3',
    :script               => 'Script 123',
    :location_id          => 1,
    :event_type_id        => 1,
    :notes                => 'Notes',
    :length               => 1157,
    :quarantine           => 'Aug 3 2006 15:30:00 GMT',
    :created_at           => 'July 16 2006 17:37:30 GMT',
    :updated_at           => 'July 16 2006 18:52:30 GMT',
    :file_location_id     => 1,
    :filename             => 'filename_event_3')

#     People.create(
#     :name                 => '',
#     :title                => '',
#     :organization         => '',
#     :phone                => '',
#     :email                => '')

    Person.create(
    :name                 => 'Lauri Pitkänen',
    :title                => 'Team leader',
    :organization         => 'Assembly',
    :phone                => '040-8243905',
    :email                => 'lauri.pitkanen@assemblytv.org')
    Person.create(
    :name                 => 'Mikael Lavi',
    :title                => 'Stream supervisor',
    :organization         => 'Assembly',
    :phone                => '050-3070020',
    :email                => 'mikael.lavi@assemblytv.org')
    Person.create(
    :name                 => 'Sakari Laitinen',
    :title                => 'Stream supervisor',
    :organization         => 'Assembly',
    :phone                => '040-7315770',
    :email                => 'sakari.laitinen@assemblytv.org')

#     Program.create(
#     :notes                => '',
#     :min_show             => '',
#     :max_show             => '',
#     :do_vod               => '',
#     :created_at           => '',
#     :updated_at           => '',
#     :preview_image_offset => '',
#     :preview_video_offset => '',
#     :owner_id             => '',
#     :status_id            => '')

    Program.create(
    :notes                => 'Notes for Program 1',
    :min_show             => 2,
    :max_show             => 7,
    :do_vod               => true,
    :created_at           => 'July 17 2006 17:00:00 GMT',
    :updated_at           => 'July 17 2006 17:10:00 GMT',
    :preview_image_offset => '00:00:30',
    :preview_video_offset => '00:00:00',
    :owner_id             => 1,
    :vod_group_id             => 1,
    :status_id            => 1,
    :file_location_id     => 1,
    :filename             => 'eka_tiedosto')
    Program.create(
    :notes                => 'Notes for Program 2',
    :min_show             => 2,
    :max_show             => 7,
    :do_vod               => true,
    :created_at           => 'July 17 2006 17:01:00 GMT',
    :updated_at           => 'July 17 2006 17:11:00 GMT',
    :preview_image_offset => '00:00:30',
    :preview_video_offset => '00:00:00',
    :owner_id             => 1,
    :vod_group_id             => 1,
    :status_id            => 1,
    :file_location_id     => 1,
    :filename             => 'toka_tiedosto')
    Program.create(
    :notes                => 'Notes for Program 3',
    :min_show             => 2,
    :max_show             => 7,
    :do_vod               => true,
    :created_at           => 'July 17 2006 17:02:00 GMT',
    :updated_at           => 'July 17 2006 17:12:00 GMT',
    :preview_image_offset => '00:00:30',
    :preview_video_offset => '00:00:00',
    :owner_id             => 1,
    :vod_group_id             => 1,
    :status_id            => 1,
    :file_location_id     => 1,
    :filename             => 'kolmas_tiedosto')

#     Playlist.create(
#     :start_time           => '',
#     :movable              => '',
#     :program_id           => '',
#     :channel_id           => '')

    Playlist.create(
    :start_time           => 'July 17 2006 17:37:00 GMT',
    :movable              => true,
    :program_id           => 1,
    :channel_id           => 1)
    Playlist.create(
    :start_time           => 'July 17 2006 17:53:00 GMT',
    :movable              => true,
    :program_id           => 2,
    :channel_id           => 1)
    Playlist.create(
    :start_time           => 'July 17 2006 18:00:00 GMT',
    :movable              => true,
    :program_id           => 3,
    :channel_id           => 1)

#     ProgramDescription.create(
#     :private_description  => '',
#     :public_description   => '',
#     :title                => '',
#     :program_id           => '',
#     :language_id          => '',
#     :position             => '')

    ProgramDescription.create(
    :private_description  => 'Private description',
    :public_description   => 'Public description',
    :title                => 'Title, english',
    :program_id           => 1,
    :language_id          => 1,
    :position             => 1)
    ProgramDescription.create(
    :private_description  => 'Yksityinen kuvaus',
    :public_description   => 'Julkinen kuvaus',
    :title                => 'Otsikko, suomi',
    :program_id           => 1,
    :language_id          => 2,
    :position             => 2)
    ProgramDescription.create(
    :private_description  => 'Private description',
    :public_description   => 'Public description',
    :title                => 'Title, english',
    :program_id           => 2,
    :language_id          => 1,
    :position             => 1)
    ProgramDescription.create(
    :private_description  => 'Yksityinen kuvaus',
    :public_description   => 'Julkinen kuvaus',
    :title                => 'Otsikko, suomi',
    :program_id           => 2,
    :language_id          => 2,
    :position             => 2)
    ProgramDescription.create(
    :private_description  => 'Private description',
    :public_description   => 'Public description',
    :title                => 'Title, english',
    :program_id           => 3,
    :language_id          => 1,
    :position             => 1)
    ProgramDescription.create(
    :private_description  => 'Yksityinen kuvaus',
    :public_description   => 'Julkinen kuvaus',
    :title                => 'Otsikko, suomi',
    :program_id           => 3,
    :language_id          => 2,
    :position             => 2)

#     ProgramEventLink.create(
#     :position             => '',
#     :program_id           => '',
#     :event_id             => '')

    ProgramEventLink.create(
    :position             => 1,
    :program_id           => 1,
    :event_id             => 1)
    ProgramEventLink.create(
    :position             => 2,
    :program_id           => 2,
    :event_id             => 2)
    ProgramEventLink.create(
    :position             => 3,
    :program_id           => 3,
    :event_id             => 3)

#     Tape.create(
#     :code                 => '',
#     :title                => '',
#     :length               => '',
#     :owner_id             => '',
#     :media_id             => '',
#     :category_id          => '')

    Tape.create(
    :code                 => 'TAPE-01',
    :title                => 'Tape 1',
    :length               => 1800,
    :owner_id             => 1,
    :media_id             => 1,
    :category_id          => 1)
    Tape.create(
    :code                 => 'TAPE-02',
    :title                => 'Tape 2',
    :length               => 1200,
    :owner_id             => 1,
    :media_id             => 1,
    :category_id          => 1)
    Tape.create(
    :code                 => 'TAPE-03',
    :title                => 'Tape 3',
    :length               => 600,
    :owner_id             => 1,
    :media_id             => 1,
    :category_id          => 1)

#     TapeEventLink.create(
#     :start_time           => '',
#     :tape_id              => '',
#     :event_id             => '')

    TapeEventLink.create(
    :start_time           => 0,
    :tape_id              => 1,
    :event_id             => 1)
    TapeEventLink.create(
    :start_time           => 810,
    :tape_id              => 1,
    :event_id             => 2)
    TapeEventLink.create(
    :start_time           => 1967,
    :tape_id              => 1,
    :event_id             => 3)

#     TapeProgramLink.create(
#     :start_time           => '',
#     :tape_id              => '',
#     :program_id           => '')

    TapeProgramLink.create(
    :start_time           => 'July 17 2006 18:00:00 GMT',
    :tape_id              => 1,
    :program_id           => 1)
    TapeProgramLink.create(
    :start_time           => 'July 17 2006 19:00:00 GMT',
    :tape_id              => 2,
    :program_id           => 2)
    TapeProgramLink.create(
    :start_time           => 'July 17 2006 20:00:00 GMT',
    :tape_id              => 3,
    :program_id           => 3)

#     VodFormat.create(
#     :name                 => '',
#     :description          => '',
#     :vcodec               => '',
#     :acodec               => '',
#     :container            => '',
#     :vbitrate             => '',
#     :abitrate             => '',
#     :width                => '',
#     :height               => '')

    VodFormat.create(
    :name                 => 'First vod format',
    :description          => 'The very first vod format of them all.',
    :vcodec               => 'vcodec',
    :acodec               => 'avodec',
    :container            => 'container',
    :vbitrate             => 64,
    :abitrate             => 82,
    :width                => 400,
    :height               => 300)

#     Vod.create(
#     :filename             => '',
#     :path                 => '',
#     :length               => '',
#     :filesize             => '',
#     :vcodec               => '',
#     :avodec               => '',
#     :container            => '',
#     :vbitrate             => '',
#     :abitrate             => '',
#     :width                => '',
#     :height               => '',
#     :updated_at           => '',
#     :program_id           => '')

    Vod.create(
    :filename             => 'filename.avi',
    :file_location_id     => 1,
    :length               => 600,
    :filesize             => 512000,
    :vod_format_id        => 1,
    :updated_at           => 'July 17 2006 20:00:00 GMT',
    :program_id           => 1)
  end

  def self.down
  end
end

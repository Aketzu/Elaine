class CreateProgramsPrograms < ActiveRecord::Migration
  def self.up
    create_table :programs_programs do |t|
			t.integer	:program_id
			t.integer :subprogram_id
			t.integer :position
      t.timestamps
    end

		foreign_key :programs_programs, :program_id, :delete => 'CASCADE'
		foreign_key :programs_programs, :subprogram_id, :foreign_table => 'programs', :delete => 'CASCADE'

		add_index :programs_programs, :program_id

		#execute "set @cc=1; set @pid=0; insert into programs_programs (program_id, subprogram_id, position, created_at, updated_at) select program_id, id, (@cc:= if(@pid<>program_id,if(@pid:=program_id,1,1),@cc+1)), now(), now() from programs where program_id is not null;"
  end

  def self.down

		drop_foreign_key :programs_programs, :program_id
		drop_foreign_key :programs_programs, :subprogram_id
		
    drop_table :programs_programs
  end
end

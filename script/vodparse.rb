#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'

#Parse vod filenames from moukari (find-style output) and update DB

File.open("script/vods.txt","r") { |f|
	f.each { |r|
		r.chomp!
		p = r.split "/"
		
		fn = p.last
		next if fn.nil?
		fn.gsub! /\.[a-z4]*$/, ""
		fn.gsub! /^[0-9]*_/, ""
		puts r + " - " + fn

		if fn.include? "preview"
			fn.gsub! /_preview/, ""
			v = Vod.find(:first, :conditions => ["filename LIKE ?", fn+"%"])
			next if v.nil?
			p = v.program
			puts p.id.to_s + ": " + p.filename + " - " + fn
			p.filename = fn
			p.save!
		else
			v = Vod.find_by_filename(fn)
			next if v.nil?
			v.full_path = "http://media.assembly.org/" + r
			v.save!
		end
	}
}

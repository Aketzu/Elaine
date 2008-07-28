#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/config/boot'
require File.dirname(__FILE__) + '/config/environment'

#Parse vod filenames from moukari (find-style output) and update DB

File.open("vods.txt","r") { |f|
	f.each { |r|
		r.chomp!
		p = r.split "/"
		
		fn = p.last
		next if fn.nil?
		fn.gsub! /\.[a-z4]*$/, ""
		fn.gsub! /^[0-9]*_/, ""
		puts r + " - " + fn

		v = Vod.find_by_filename(fn)
		next if v.nil?
		v.full_path = "http://media.assembly.org/" + r
		v.save!
	}
}

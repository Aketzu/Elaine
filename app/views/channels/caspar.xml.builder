xml.instruct!
xml.programs {
  #@channel.playlists.each { |pl|
  @programs.each { |prog|
    #prog = pl.program
    xml.program {
      xml.name prog.title
      #xml.clips {
      #  prog.children.each {|sp|
      #    xml.clip {
      #      xml.name sp.title
      #      xml.filename sp.filename
      #    }
      #  }
      #}
      xml.clips {
        prog.runlists.find(:all, :conditions => {:video => "KN"}).each {|rl|
          cl = rl.content.split ";"
          xml.clip {
            xml.name cl[0]
            xml.filename cl[1]
          }
        }
      }

      
      xml.TG {
        prog.runlists.each {|rl|
          next if !rl.tg || rl.tg.empty?
          longtext=false
          titleparam=""
          cc=-1

          rl.tg.each_line {|tg|
            next if tg.empty?
            next if longtext
            next unless tg =~ /^[0-9]/
            cc=cc+1

            xml.TGClip {
              nn = "?"
              nn = "Ohjelman nimi" if rl.tg.start_with? "1;"
              nn = "Nimiplanssi" if rl.tg.start_with? "2;"
              nn = "Kokoruutu" if rl.tg.start_with? "3;"
              nn = "Lopputekstit" if rl.tg.start_with? "4;"
              xml.name nn
              xml.filename ""
              xml.parameters {

                xml.parameter {
                  if tg.start_with? "1;"
                    xml.id "f" + cc.to_s
                    xml.label "ohjelman_nimi"
                    xml.value rl.tg[2..-1]
                    xml.type "INPUTBOX"
                  elsif tg.start_with? "2;"
                    tgg = tg.split ";"
                    xml.id "f" + cc.to_s
                    xml.label "nimiplanssi"
                    xml.value tgg[1]
                    titleparam = tgg[2]
                    titleparam ||= ""
                    cc=cc+1
                    xml.type "INPUTBOX"
                  elsif tg.start_with? "3;"
                    tgg = tg.split ";"
                    xml.id "f" + cc.to_s
                    xml.label "kokoruutu"
                    xml.value tgg[1]
                    xml.type "INPUTAREA"
                  elsif tg.start_with? "4;"
                    xml.id "f" + cc.to_s
                    xml.label "lopputekstit"
                    xml.value rl.tg[2..-1].gsub("\n", "<br />")
                    longtext = true
                    xml.type "INPUTAREA"
                  end
                }
                xml.parameter {
                  xml.id "f" + cc.to_s
                  xml.label "titteli"
                  xml.value titleparam
                  xml.type "INPUTBOX"
                } unless titleparam.empty?
              }
            }
          }
        }
      }
    }

  }
}


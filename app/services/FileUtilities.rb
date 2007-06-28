require 'weborb/context'
require "rexml/document"
include REXML 

class FileUtilities
    def explore_directory(f)

      doc = Document.new("<node></node>")
      
      doc.root.attributes["label"] = f
      doc.root.attributes["directory"] = "true"
      traverse_directory(f, doc.root)

      return doc.to_s
    
    end

    def traverse_directory(directory, xml_doc)
      
      Dir.foreach(directory) do  |x|
        if(x != "." and x != "..")
        
	     node = xml_doc.add_element("node")
	     node.attributes["label"] = x
	
	      if(File.directory?(directory + "/" + x))
	        node.attributes["directory"] = "true"
	        traverse_directory(directory + "/" + x, node)
	      else
	        node.attributes["directory"] = "false"
	      end
	  end  
        end
    end

end
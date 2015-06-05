# SuperFile

Ruby-Gem to deal with files. A kind of Ruby's Pathname with usefull methods.

## Quick examples

~~~ruby

    require 'superfile'
    
    myfolder = SuperFile::new 'path/to/my/folder'
    
    myfolder.build unless myfolder.exist?
    # Build folder if doesn't exist
    
    myfolder.folder?      # => true!
    myfolder.directory?   # => true!
    myfolder.file?        # => false
    
    myfolder.download
    # On a website, let user downloads folder (zipped)
    
    myfolder.zip
    # => Zip the folder
    
    myfile = myfolder + 'a_file.erb'
    # => New SuperFile instance
    
    myfile.write "<div>Hello <%= pseudo %>!</div>"
    # => Write to file
    
    myfile.append "<div>Some stuff again!</div>"
    # => Add text to file
    
    myfile.deserb user
    # => Parse ERB file with binding user
    # Note: <user> is a User instance with `pseudo` method
    
    myfile.remove if myfile.exist?
    
    myfile.code_html
    # => HTML code from file, no matter myfile type, converting
    #    it if possible (markdown, erb, etc.)
~~~
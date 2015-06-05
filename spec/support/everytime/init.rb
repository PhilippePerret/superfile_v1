
class MyTest
  attr_reader :pfolder
  attr_reader :pfoldertmp
  attr_reader :pinexistant
  attr_reader :pfile
  attr_reader :pfileerb
  attr_reader :pfilemd
  attr_reader :pfilehtml
  
  def init

    require './lib/superfile'
    
    raise "SuperFile devrait exister" unless defined? SuperFile
    
    @pfoldertmp   = @pfolder = SuperFile::new './tmp/'
    
    @pinexistant  = @pfoldertmp + 'nimportequoi'

    @pfile        = @pfoldertmp + 'fichiertest.txt'
    @pfile.write "un texte provisoire"

    @pfileerb     = @pfoldertmp + 'fichiertest.erb'
    @pfileerb.write "<%# Fichier erb de test %>\n<div>Un texte</div>"

    @pfilemd      = @pfoldertmp + 'fichiertest_update.md'
    @pfilemd.write "#Grand titre\n\nLe paragraphe du fichier md\n\n##Sous titre"

    @pfilehtml    = @pfoldertmp + 'fichiertest.html'
    @pfilehtml.write "<div>Un simple fichier HTML headless.</div>"
    
  end
end
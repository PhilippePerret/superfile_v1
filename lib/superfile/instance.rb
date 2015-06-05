# encoding: UTF-8
class SuperFile
  
  def initialize given_path
    given_path = File.join( given_path ) if given_path.class == Array
    unless given_path.class == String
      raise ArgumentError, "SuperFile doit être instancié avec un string (path) ou un array (['path', 'to', 'the', 'file'])"
    end
    @path = given_path
  end
  
  # Ré-initialise toutes les propriétés
  # NE PAS OUBLIER DE REDÉFINIR @path JUSTE APRÈS
  def reset
    # @path         = nil
    @dirname          = nil
    @name             = nil
    @expanded_path    = nil
    @errors           = nil
    @code_html        = nil
    @affixe           = nil
    @extension        = nil
    @path_affixe      = nil
    @is_file          = nil
    @is_markdown      = nil
    @html_path        = nil
    @zip_path         = nil
    @extension_valid  = nil
  end
  
end

# Require all instance modules
folder_instance = File.join(SuperFile::root, 'lib', 'superfile', 'instance')
raise "Impossible de trouver #{folder_instance}" unless File.exist? folder_instance
Dir["#{folder_instance}/**/*.rb"].each { |m| require m }
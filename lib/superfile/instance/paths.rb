# encoding: UTF-8
class SuperFile
  
  # {SuperFile} Le path du fichier HTML du fichier markdown
  def html_path
    @html_path ||= path_with_ext 'html'
  end
  
  # {SuperFile} Fichier zip du fichier/dossier
  def zip_path
    @zip_path ||= path_with_ext 'zip'
  end
  
end
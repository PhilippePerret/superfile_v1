# encoding: UTF-8
class SuperFile
  
  
  # Ajoute un chemin à la path courante et retourne une nouvelle
  # instance SuperFile
  def + pathrel
    raise "Impossible d'ajouter un path à un fichier" if file?
    raise ArgumentError, "L'argument de la méthode SuperFile#+ ne peut être NIL" if pathrel.nil?
    pathrel = ( File.join pathrel ) if pathrel.class == Array
    ::SuperFile::new File.join(path, pathrel.to_s)
  end

  # Retire du path la valeur de {String|SuperFile} pathmoins
  def - pathmoins
    psup = pathmoins.to_s.dup
    psup << "/" unless psup.end_with? '/'
    self.path.sub(/^#{Regexp::escape psup}/, '')
  end
  
end
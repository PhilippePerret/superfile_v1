# encoding: UTF-8
class SuperFile
  
  
  # Construit le dossier
  # (et toute la hiérarchie nécessaire)
  # @return TRUE en cas de succès
  # Sinon, retourne FALSE et produit une erreur
  def build
    if exist?
      error ERRORS[:already_exists] % {path: self.path}
    else
      begin
        make_dir self.path
        return self.exist?
      rescue Exception => e
        error e.message
      end
    end
  end
  
  # Build path hierarchie up to file path
  # If +up_to_path+ is nil, build up to current file
  # So :
  #   sf = SuperFile::new '/path/to/my/folder
  #   sf = sf.make_dir
  #   # =>  build '/path', then '/path/to', 'then '/path/to/my'
  #   #     then '/path/to/my/folder' if needed
  #
  def make_dir up_to_path = nil
    up_to_path ||= path
    `if [ ! -d "#{up_to_path}" ];then mkdir -p "#{up_to_path}";fi`
  end
    
  
  # Détruit le fichier ou le dossier
  def remove
    if exist?
      if file?
        File.unlink path
      else
        ::FileUtils::rm_rf path
      end
      return true
    else
      add_error ERRORS[:inexistant] % {path: path}
      return true
    end
  end
  
  # Requiert le fichier ou tous les fichiers ruby du dossier (tous
  # ceux qui sont à la racine)
  alias :top_require :require
  def require
    if exist?
      if file?
        top_require path
      else
        Dir["#{path}/*.rb"].each do |m| top_require m end
      end
      return true
    else
      add_error ERRORS[:inexistant] % {path: path}
      return nil
    end
  end
  
  # Download le fichier/dossier
  # On en fait toujours un zip avant de le transmettre
  def download
    raise "Impossible de zipper le file #{path}…" unless zip && zip_path.exist?
    unless RestSite::mode_test?
      STDOUT.puts "Content-type: application/zip"
      STDOUT.puts "Content-disposition: attachment;filename=\"#{zip_path.name}\""
      STDOUT.puts "Content-length: #{zip_path.size}"
      STDOUT.puts ""
      STDOUT.puts File.open( zip_path.expanded_path, 'rb'){ |f| f.read }
    end
    zip_path.remove
    # Est-ce qu'il faut interrompre ici ?
    return true
  end
  
  
  # Upload d'un fichier
  # +tempfile+  Soit le StringIO du fichier, soit l'identifiant d'un
  #             paramètre le contenant.
  # +option+    {Hash} d'options
  #   :change_name      Si FALSE, ne modifie pas le nom de ce fichier
  #                     Si TRUE (défaut), le nom donné à l'instanciation de
  #                     ce superfile est remplacé par le nom du fichier à 
  #                     uploader
  class NotAUploadedFile < StandardError; end
  def upload tempfile, options = nil
    return error "Il faut fournir le fichier des données à importer" if tempfile == ""
    if [String, Symbol].include?( tempfile.class ) 
      case param(tempfile)
      when NilClass then raise ArgumentError, "Le paramètre `:#{tempfile}' est inconnu."
      else tempfile = param(tempfile)
      end
    end
    raise NotAUploadedFile unless tempfile.respond_to? :original_filename
    options ||= {}
    
    # Nom du fichier
    # --------------
    # On l'attribue au superfile courant, sauf indication contraire
    unless options[:change_name] === false
      tempfile_name = tempfile.original_filename
      good_path = (dirname + tempfile_name).path
      reset # pour forcer le recalcul des propriétés
      @name = tempfile_name
      @path = good_path
    end
    
    # On écrit le fichier
    # --------------------
    self.write tempfile.read.force_encoding('UTF-8')
  
  rescue NotAUploadedFile => e
    raise ArgumentError, "L'argument envoyé à SuperFile#upload doit être le fichier StringIO du formulaire ou la clé (String ou Symbol) du paramètre qui le contient. Impossible d'uploader le fichier"
  rescue ArgumentError => e
    raise ArgumentError, "#{e.message} Impossible d'uploader le fichier"
  rescue Exception => e
    error e
  else
    return true
  end
  
  # Zip le fichier/dossier
  def zip params = nil
    params ||= {}
    zip_final_path = if params.has_key?( :filename )
      params[:filename].expanded_path
    else
      zip_path.name
    end
    cmd = ""
    cmd << "cd \"#{dirname}\";"
    cmd << "zip "
    cmd << "-r " unless file?
    cmd << " \"#{zip_final_path}\" \"#{name}\""
    res = `#{cmd}`
    return zip_path.exist?
  end
  
    
  # Actualise le fichier si Markdown
  # @return TRUE si l'actualisation a pu se faire
  # sinon FALSE
  def update
    unless exist? && markdown?
      return error( ERRORS[:inexistant] % {path: path} ) unless exist?
      return error "La méthode #update ne s'applique qu'aux fichiers Markdown"
    end
    # On peut opérer à l'actualisation
    top_require "kramdown"
    top_require "coderay"
    chtml = Kramdown::Document.new(read, auto_ids: false, coderay_line_numbers: nil, coderay_default_lang: 'fr', syntax_highlighter: :coderay, coderay_css: :style).to_html
    # Ne pas utiliser le nom `code_html' qui est une propriété de l'instance
    html_path.remove if html_path.exist?
    html_path.write chtml
    return true
  end
  
end
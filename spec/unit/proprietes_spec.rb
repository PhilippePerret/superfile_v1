=begin
Ce module contient :
  - les tests des méthodes d'instances de SuperFile
  - les tests des paths définies (méthodes de classes)
=end
describe "Propriétés de SuperFile", focus: true do

  lets_in_describe
  

  #to_str
  describe "#to_str" do
    it { expect(p).to respond_to :to_str }
    it { expect( "#{p}" ).to eq( './tmp/fichiertest.txt' ) }
  end
  
  #to_s
  describe "#to_s" do
    it { expect(p).to respond_to :to_s }
    it { expect(p.to_s).to eq('./tmp/fichiertest.txt')}
  end
  
  #name
  describe "#name" do
    it { expect(p).to respond_to :name }
    it { expect(p.name).to eq("fichiertest.txt") }
    it { expect(pfolder.name).to eq('tmp') }
  end
  
  # #dirname
  describe "#dirname" do
    it { expect(p).to respond_to :dirname }
    it { expect(p.dirname.path).to eq("./tmp") }
    it { expect(pfolder.dirname.path).to eq(File.dirname(pfolder)) }
  end
  
  # #folder (alias de dirname)
  describe "#folder" do
    it { expect(p).to respond_to :folder }
    it { expect(p.folder.path).to eq("./tmp") }
    it { expect(pfolder.folder.path).to eq(File.dirname(pfolder)) }
  end
  
  # #affixe
  describe "#affixe" do
    it { expect(p).to respond_to :affixe }
    it { expect(p.affixe).to eq("fichiertest") }
  end
  
  #path_affixe
  describe "#path_affixe" do
    it { expect(p).to respond_to :path_affixe }
    it { expect(p.path_affixe).to eq((p.folder + "fichiertest").to_s) }
  end

  #size
  describe "#size" do
    it { expect(p).to respond_to :size }
    
    context "avec un fichier existant" do
      it "retourne la taille du fichier" do
        expected = File.stat(pfile.path).size
        expect(pfile.size).to eq(expected)
      end
    end
    context "avec un dossier existant" do
      it "retourne la taille du dossier" do
        expected = File.stat(pfolder.path).size
        expect(pfolder.size).to eq(expected)
      end
    end
    context "avec un file inexistant" do
      it { expect(pinexistant.size).to eq(nil) }
      it "produit un message d'erreur" do
        pinexistant.errors = nil
        pinexistant.size
        expect(pinexistant.errors).to_not be_nil
        expect(pinexistant.errors).to include (SuperFile::ERRORS[:inexistant] % {path: pinexistant.to_s})
      end
    end
  end
  
  #mtime
  describe "#mtime" do
    it { expect(p).to respond_to :mtime }
    context "avec un fichier existant" do
      it "retourne la date de dernière modification" do
        expected = File.stat(pfile).mtime
        expect(pfile.mtime).to eq(expected)
      end
    end
    context "avec un dossier existant" do
      it "retourne la date de dernière modification (du plus vieux fichier)" do
        expected = File.stat(pfolder).mtime
        expect(pfolder.mtime).to_not eq(nil)
        expect(pfolder.mtime).to eq(expected)
      end
    end
    context "avec un file inexistant" do
      it { expect(pinexistant.mtime).to eq(nil) }
      it "produit une erreur d'inexistence" do
        pinexistant.errors = nil
        pinexistant.mtime
        expect(pinexistant.errors).to_not be_nil
        expect(pinexistant.errors).to include (SuperFile::ERRORS[:inexistant] % {path: pinexistant.to_s})
      end
    end
  end
  
  
  # #path_with_ext
  describe "#with_ext" do
    it { expect(p).to respond_to :path_with_ext }
    context "en fournissant une extension sans point" do
      it "retourne le path avec l'extension fournie" do
        expected = "./tmp/fichiertest.cor"
        expect(p.path_with_ext( 'cor').to_s).to eq(expected)
      end
    end
    context "en fournissant une extension avec point" do
      it "retourne le bon path avec l'extension fournie" do
        expected = "./tmp/fichiertest.ver"
        expect(p.path_with_ext('ver').to_s).to eq(expected)
      end
    end
  end
  
  #expanded_path
  describe "#expanded_path" do
    it { expect(pfolder).to respond_to :expanded_path }
    it { expect(pfolder.expanded_path).to be_instance_of String }
    it "retourne le path étendu" do
      expected = File.expand_path pfolder.path
      expect(pfolder.expanded_path).to start_with '/'
      expect(pfolder.expanded_path).to eq(expected)
    end
  end
  
  #zip_path
  describe "#zip_path" do
    it { expect(pfolder).to respond_to :zip_path }
    it {  expect(pfolder.zip_path).to be_instance_of ::SuperFile }
    it { expect(pfolder.zip_path.to_s).to eq('./tmp.zip') }
  end
end
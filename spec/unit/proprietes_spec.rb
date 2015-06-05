=begin
Ce module contient :
  - les tests des méthodes d'instances de SuperFile
  - les tests des paths définies (méthodes de classes)
=end
describe "Propriétés de SuperFile" do

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
  
  #affixe
  describe "#affixe" do
    it { expect(p).to respond_to :affixe }
    it { expect(p.affixe).to eq("fichiertest") }
  end
  
  #extension
  describe "#extension" do
    it { expect(p).to respond_to :extension }
    context "avec un dossier" do
      it { expect(pfolder.extension).to eq(nil) }
    end
    context "avec un fichier" do
      it "retourne la bonne extension" do
        {
          'fichier.txt' => 'txt', 
          'fichier.mov' => 'mov', 
          'fichier.txt.mov' => 'mov', 
          'fichier.html' => 'html'
        }.each do |fname, expected|
          prov = pfoldertmp + fname
          expect(prov.extension).to eq(expected)
        end
      end
    end
  end
  
  #dirname
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
  
  
end
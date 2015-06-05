=begin
Ce module contient :
  - les tests des méthodes d'instances de SuperFile
  - les tests des paths définies (méthodes de classes)
=end
# require 'superfile'

describe "SuperFile" do
  before :all do

    require './lib/superfile'
    puts File.expand_path('.')

    @pfoldertmp   = SuperFile::new './tmp/'
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
  after :all do
    @pfoldertmp.remove if @pfoldertmp.exist?
  end
  
  let(:classe)      { SuperFile }
  let(:p)           { @pfile }
  let(:pfoldertmp)  { @pfoldertmp }
  let(:pfile)       { @pfile }
  let(:pfileerb)    { @pfileerb }
  let(:pfilemd)     { @pfilemd }
  let(:pfilemarkdown) do
    @pfilemarkdown ||= begin
      p = @pfoldertmp + 'dans/sousdossier/file.markdown'
      p.write "# Le titre\n\n> La note"
      p
    end
  end
  let(:pfilehtml)   { @pfilehtml }
  let(:pinexistant) { @pinexistant }

  # #exist?
  describe "#exist?" do
    it {expect(p).to respond_to :exist?}
    context "avec un fichier existant" do
      it { expect(p.exist?).to eq(true) }
    end
    context "avec un fichier inexistant" do
      it { expect(pinexistant.exist?).to eq(false) }
    end
  end

  # #directory?
  describe "#directory?" do
    it { expect(p).to respond_to :directory? }
    context "avec un fichier" do
      it { expect(pfile).to_not be_directory }
    end
    context "avec un dossier" do
      it { expect(pfoldertmp).to be_directory }
    end
    context "avec un file inexistant" do
      it { expect(pinexistant.directory?).to eq(nil) }
    end
  end
  
  #folder?
  describe "#folder?" do
    it { expect(p).to respond_to :folder? }
    context "avec un fichier" do
      it { expect(pfile).to_not be_folder }
    end
    context "avec un dossier" do
      it { expect(pfoldertmp).to be_folder }
    end
    context "avec un file inexistant" do
      it { expect(pinexistant.folder?).to eq(nil) }
    end
  end

  #file?
  describe "#file?" do
    it { expect(p).to respond_to :file? }
    context "avec un file inexistant" do
      it { expect(pinexistant.file?).to eq(nil) }
    end
    context "avec un fichier" do
      it { expect(pfile).to be_file }
    end
    context "avec un dossier" do
      it { expect(pfoldertmp).to_not be_file }
    end
  end

  #markdown?
  describe "#markdown?" do
    it { expect(p).to respond_to :markdown? }
    context "avec un élément inexistant" do
      it { expect(pinexistant).to_not be_markdown }
    end
    context "avec un élément existant" do
      context "avec un dossier" do
        it { expect(pfoldertmp).to_not be_markdown }
      end
      context "avec un fichier qui n'est pas markdown" do
        it { expect(pfileerb).to_not be_markdown }
      end
      context "avec un fichier .md" do
        it { expect(pfilemd).to be_markdown }
      end
      context "avec un fichier .markdown" do
        it { expect(pfilemarkdown).to be_markdown }
      end
    end
  end
  #uptodate?
  describe "#uptodate?" do
    it { expect(pfilemd).to respond_to :uptodate? }
    context "avec un fichier markdown" do
      it "Retourne true si le fichier est à jour" do
        expect(pfilemd.update).to eq(true)
        expect(pfilemd).to be_uptodate
      end
      it "retourne false si le fichier HTML n'existe pas" do
        fhtml = pfilemd.html_path
        fhtml.remove if fhtml.exist?
        expect(pfilemd).to_not be_uptodate
      end
      it "Retourne false si le fichier n'est pas à jour" do
        pfilemd.write pfilemd.read
        expect(pfilemd).to_not be_uptodate
      end
    end
    context "avec un dossier" do
      it "produit une erreur" do
        expect{pfoldertmp.uptodate?}.to raise_error "La méthode #uptodate? ne s'applique qu'aux fichiers Markdown."
      end
    end
    context "avec un fichier autre que markdown" do
      it "produit une erreur" do
        [pfile, pfileerb, pfilehtml].each do |rs_path|
          expect{rs_path.send(:uptodate?)}.to raise_error "La méthode #uptodate? ne s'applique qu'aux fichiers Markdown."
        end
      end
    end
  end


  # #older_than?
  describe "#older_than?" do
    before :all do
      @pyoung = SuperFile::new File.join(@pfoldertmp, "adetuire.md")
      sleep 1 # pour obtenir un fichier plus jeune
      @pyoung.write "Du texte"
    end
    after :all do
      @pyoung.remove if @pyoung.exist?
    end
    it { expect(p).to respond_to :older_than? }
    context "avec un file inexistant" do
      it "retourne nil" do
        expect(pfile.older_than? pinexistant).to eq( nil )
      end
      it "produit une erreur" do
        pfile.errors = nil
        pfile.older_than? pinexistant
        expect(pfile.errors).to include (SuperFile::ERRORS[:inexistant] % {path: pinexistant.to_s})
      end
    end
    context "avec deux fichiers de même date" do
      context "si strict est mis à true" do
        it "retourne false" do
          expect(pfile.older_than? pfile, true).to eq(false)
        end
      end
      context "si strict est à false (valeur par défaut)" do
        it "retourne true" do
          expect(pfile.older_than? pfile).to eq(true)
        end
      end
    end
    context "avec un fichier (sujet) plus vieux que l'argument" do
      it "retourne true" do
        expect(pfile.older_than? @pyoung).to eq(true)
      end
    end
    context "avec un fichier (sujet) plus jeune que l'argument" do
      it "retourne false" do
        expect(@pyoung.older_than? pfile).to eq(false)
      end
    end
  end


end
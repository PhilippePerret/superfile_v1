=begin
Ce module contient :
  - les tests des méthodes d'instances de SuperFile
  - les tests des paths définies (méthodes de classes)
=end
describe "SuperFile" do
  
  lets_in_describe
  before :all do

    mytest.pfile.write "un texte provisoire"
    mytest.pfileerb.write "<%# Fichier erb de test %>\n<div>Un texte</div>"
    mytest.pfilemd.write "#Grand titre\n\nLe paragraphe du fichier md\n\n##Sous titre"
    mytest.pfilehtml.write "<div>Un simple fichier HTML headless.</div>"

  end

  #build
  describe "#build" do
    it { expect(p).to respond_to :build }
    context "avec un file déjà existant" do
      it "produit une erreur" do
        `if [ ! -d "#{pfolder}" ];then mkdir -p "#{pfolder}";fi`
        expect(pfolder).to be_exist
        expect{ pfolder.build }.to raise_error
      end
    end
    context "avec un dossier dans un dossier existant" do
      before :all do
        @subfolder = mytest.pfoldertmp + "sousdossier"
      end
      after :all do 
        @subfolder.remove if @subfolder.exist?
      end
      it { expect(@subfolder.build).to eq(true) }
      it { expect(@subfolder).to be_exist }
    end
    context "avec un dossier dans un dossier inexistant" do
      before :all do
        @parent     = mytest.pfoldertmp + "sousdossier/comme/parent"
        @parent.remove if @parent.exist?
        @subfolder  = @parent + "sousousdossierinparent"
      end
      after :all do
        @parent.remove if @parent.exist?
      end
      it { expect(File.exist? @parent).to eq(false) }
      it { expect(@subfolder.build).to eq(true) }
      it { expect(@subfolder).to be_exist }
    end
  end
  
  #make_dir
  describe "#make_dir" do
    it { expect(p).to respond_to :make_dir }
    context "avec un dossier" do
      context "sans argument" do
        before :all do
          @pfold = mytest.pfoldertmp + "dans/ce/dossier/makedir"
        end
        after :all do
          @pfold.remove if @pfold.exist?
        end
        it "construit le path jusqu'au dossier" do
          expect(@pfold).to_not be_exist
          @pfold.make_dir
          expect(@pfold).to be_exist
        end
      end
      context "avec un argument" do
        before :all do
          @pfold = mytest.pfoldertmp + "meme/un/makedir/args"
        end
        after :all do
          @pfold.remove if @pfold.exist?
        end
        it "construit le path" do 
          @pfold.make_dir @pfold.path
          expect(@pfold).to be_exist
        end
      end
    end
    context "avec un fichier" do
      before :all do
        @file = mytest.pfoldertmp + "un/makedir/de/fichier.txt"
      end
      after :all do
        @file.remove if @file.exist?
      end
      context "sans argument" do
        it "construit malheureusement un dossier" do
          expect(@file).to_not be_exist
          @file.make_dir
          expect(@file).to be_exist
          expect(@file).to be_folder
        end
      end
      context "avec un argument" do
        before :all do
          @file.folder.remove if @file.folder.exist?
        end
        after :all do
          @file.folder.remove if @file.folder.exist?
        end
        it "construit le path au dossier fourni en argument" do
          expect(@file.folder).to_not be_exist
          @file.make_dir @file.folder
          expect(@file.folder).to be_exist
        end
      end
    end
  end
  
  #update (seulement pour fichier Markdown)
  describe "#update" do
    it { expect(pfilemd).to respond_to :update }
    context "avec un dossier" do
      it { expect{ pfoldertmp.update }.to raise_error }
    end
    context "avec un fichier autre que .md" do
      it { expect{ pfileerb.update }.to raise_error }
      it { expect{ pfileruby.update }.to raise_error }
    end
  end
  
  #remove
  describe "#remove" do
    it { expect(p).to respond_to :remove }
    context "avec un file inexistant" do
      it { expect{pinexistant.remove}.to raise_error "Unable to find file #{pinexistant}"}
    end
    context "avec un fichier existant" do
      before :all do
        @fileasup = mytest.pfolder + 'untestremove.txt'
        @fileasup.write "Un texte"
      end
      it "le détruit" do
        expect(@fileasup).to be_exist
        @fileasup.remove
        expect(@fileasup).to_not be_exist
      end
    end
  end
  
  #require
  describe "#require" do
    it { expect(p).to respond_to :require }
    context "avec un fichier" do
      it "requiert le fichier" do
        classname = "NewClass#{Time.now.to_i}"
        nfile = mytest.pfolder + 'pouruneclasseasup.rb'
        nfile.write "class #{classname}; end"
        expect{ Object.const_get(classname) }.to raise_error
        nfile.require
        expect{ Object.const_get(classname) }.to_not raise_error
      end
    end
    context "avec un dossier" do
      before :all do
        sleep 1
        @classname = "NewClass#{Time.now.to_i}"
        @fasup    = mytest.pfolder + 'folderasup'
        @infolder = SuperFile::new [ @fasup, 'provasup.rb' ]
        @infolder.write "class #{@classname}; end"
      end
      after :all do
        @fasup.remove
      end
      it "requiert tous les éléments du dossier" do
        expect{ Object.const_get(@classname)}.to raise_error
        @fasup.require
        expect{ Object.const_get(@classname)}.to_not raise_error
      end
    end
    context "avec un file inexistant" do
      it { expect{pinexistant.require}.to raise_error "Unable de require file #{pinexistant}: it doesn't exist." }
    end
  end

end
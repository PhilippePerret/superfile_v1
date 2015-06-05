describe "Méthodes d'entrée/sortie de SuperFile" do
  
  lets_in_describe
  
  #write
  describe "#write" do
    it { expect(p).to respond_to :write }
    context "avec un dossier" do
      it { expect{pfolder.write "ça"}.to raise_error "Can't write a folder…" }
    end
    context "avec un fichier" do
      before :all do
        @texte = "un texte à #{Time.now}"
      end
      it { expect(pfile.write @texte).to eq(true) }
      it "écrit le texte dans le fichier" do
        comp = File.read(pfile)
        expect(comp).to eq(@texte)
      end
      it { expect(File.exist? pfile).to eq(true) }
    end
    context "avec un fichier dans une hiérarchie inexistante" do
      before :all do
        @fp = mytest.pfolder + 'provsousfolder'
        @thefile = @fp + 'prov' + "thefile.txt"
      end
      after :all do
         @fp.remove if @fp.exist?
      end
      it "construit la hiérarchie de dossier et le fichier" do
        @thefile.write "ce texte provisoire"
        expect(@thefile).to be_exist
      end
    end
  end
  
  #add
  describe "#add" do
    it "répond" do
      expect(p).to respond_to :add
    end
    context "avec un fichier inexistant" do
      it "le crée en y mettant le texte et retourne true" do
        pfile.remove
        expect(pfile).to_not be_exist
        res = pfile.add "du texte"
        expect(res).to eq(true)
        expect(pfile).to be_exist
        expect(pfile.read).to eq("du texte")
      end
    end
    context "avec un dossier" do
      it { expect{ pfolder.add "du texte"}.to raise_error "Can't add to a folder…" }
    end
    context "avec un fichier existant" do
      before :all do
        mytest.pfile.write "Le texte initial"
      end
      it "ajoute au bout du fichier et retourne true" do
        res = pfile.add "\nDu texte"
        expect(res).to eq(true)
        expect(pfile.read).to match "Du texte"
        expect(pfile.read).to match "Le texte initial"
      end
    end
  end
  
  #append (alias de #add)
  describe "#append" do
    it { expect(pfile).to respond_to :append }
  end
  
  # #read
  describe "#read" do
    it { expect(p).to respond_to :read }
    context "avec un dossier" do
      before :all do
        @first_tmp = mytest.pfoldertmp + "unfichierfirst.rb"
        @first_tmp.write "du texte"
        @two_tmp    = mytest.pfoldertmp + "unfichiertwo.txt"
        @two_tmp.write "de l'autre texte"
      end
      it "retourne la liste des NAMES de files" do
        arr = pfolder.read
        expect(arr).to be_instance_of Array
        expect(arr).to include( @first_tmp.name )
        expect(arr).to include( @two_tmp.name )
      end
    end
    context "avec un fichier existant" do
      it "retourne son contenu" do
        expected = File.read(pfile).force_encoding('utf-8')
        expect(pfile.read).to eq(expected)
      end
    end
    context "avec un fichier inexistant" do
      it { expect{pinexistant.read}.to raise_error }
    end
  end
  
  #puts
  describe "#puts" do
    it { expect(p).to respond_to :puts }
    context "avec un fichier inexistant" do
      it { expect{pinexistant.puts}.to raise_error SuperFile::ERRORS[:inexistant] % {path: pinexistant.to_s} }
    end
    context "avec un dossier" do
      it { expect{pfolder.puts}.to raise_error "Can't (out)put a folder…" }
    end
    context "avec un fichier valide (ERB)" do
      before :all do
        @id_div = "mondiv#{Time.now.to_i}"
        @text = "Le fichier à #{Time.now}"
        mytest.pfileerb.write "<div id='#{@id_div}'>#{@text}</div>"
      end
      it "écrit le code en sortie" do
        tmpoutput = pfoldertmp + 'outputprov.txt'
        fd      = IO.sysopen(tmpoutput.path, "w")
        $stdout = IO.new( fd ,"w")
        pfileerb.puts
        $stdout.flush
        code = tmpoutput.read.to_s
        tmpoutput.remove if tmpoutput.exist?
        $stdout = STDOUT
        
        expect(code).to have_tag('div', with: {id: @id_div}, text: @text)
        # puts code
      end
    end
  end
  
  
end
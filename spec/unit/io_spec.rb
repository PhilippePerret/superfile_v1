describe "Méthodes d'entrée/sortie de SuperFile" do
  
  lets_in_describe
  
  #write
  describe "#write" do
    it { expect(p).to respond_to :write }
    context "avec un dossier" do
      it { expect(pfolder.write "ça").to eq(false) }
      it "produit une erreur" do
        pfolder.errors = nil
        pfolder.write "ce texte"
        expect(pfolder.errors).to_not eq(nil)
        expect(pfolder.errors).to include SuperFile::ERRORS[:cant_write_a_folder]
      end
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
        @fp = File.join @pfolder, 'provsousfolder'
        @thefile = SuperFile::new File.join(@fp, 'prov', "thefile.txt")
      end
      after :all do
         FileUtils::rm_rf @fp if File.exist? @fp
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
        remove_errors
        pfile.remove
        expect(pfile).to_not be_exist
        res = pfile.add "du texte"
        expect(res).to eq(true)
        expect(pfile).to be_exist
        expect(pfile.read).to eq("du texte")
      end
    end
    context "avec un dossier" do
      it "produit une erreur et retourne false" do
        remove_errors
        res = pfolder.add "Du texte"
        expect(res).to eq(false)
        expect(RestSite).to have_error "Impossible d'écrire dans un dossier…"
      end
    end
    context "avec un fichier existant" do
      before :all do
        @pfile.write "Le texte initial"
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
      it "retourne la liste des NAMES de files" do
        arr = pfolder.read
        expect(arr).to be_instance_of Array
        expect(arr).to include( "main.rb")
      end
    end
    context "avec un fichier existant" do
      it "retourne son contenu" do
        expected = File.read(pfile).force_encoding('utf-8')
        expect(pfile.read).to eq(expected)
      end
    end
    context "avec un fichier inexistant" do
      it { expect(pinexistant.read).to eq(nil) }
      it "produit une erreur" do
        pinexistant.errors = nil
        pinexistant.read
        expect(pinexistant.errors).to_not eq(nil)
        expect(pinexistant.errors).to include (SuperFile::ERRORS[:inexistant] % {path: pinexistant.to_s})
      end
    end
  end
  
  #puts
  describe "#puts" do
    it { expect(p).to respond_to :puts }
    context "avec un dossier" do
      it { expect(pfolder.puts).to eq(nil) }
      it "produit une erreur" do
        pfolder.errors = nil
        pfolder.puts
        expect(RestSite).to have_error "Impossible d'écrire un dossier dans la page…"
      end
    end
    context "avec un fichier inexistant" do
      it { expect(pinexistant.puts).to eq(nil) }
      it "produit une erreur" do
        pinexistant.errors = nil
        pinexistant.puts
        expect(pinexistant.errors).to_not eq(nil)
        expect(pinexistant.errors).to include (SuperFile::ERRORS[:inexistant] % {path: pinexistant.to_s})
      end
    end
    context "avec un fichier valide (ERB)" do
      before :all do
        remove_body_content
        @id_div = "mondiv#{Time.now.to_i}"
        @pfileerb.write "<div id='#{@id_div}'>Le fichier à #{Time.now}</div>"
      end
      it { expect(pfileerb.puts).to eq(true) }
      it "écrit le code dans la page" do
        pfileerb.puts
        expect(body_content).to have_tag('div', with: {id: @id_div})
      end
    end
  end
  
  
end
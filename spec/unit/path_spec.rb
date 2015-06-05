=begin
Ce module contient :
  - les tests des méthodes d'instances de SuperFile
  - les tests des paths définies (méthodes de classes)
=end
describe "Méthodes de path de SuperFile" do

  lets_in_describe

  #path
  describe "#path" do
    it { expect(p).to respond_to :path }
    it "retourne un String" do
      expect(p.path).to be_instance_of String
    end
    it "retourne le bon path" do
      expect(pfolder.path).to eq('./tmp/')
    end
  end
  
  #expanded_path
  describe "#expanded_path" do
    it { expect(p).to respond_to :expanded_path }
    it { expect(p.expanded_path).to be_instance_of String }
    it "retourne le chemin complet" do
      p = File.expand_path( pfolder.path )
      expect(p).to start_with '/'
      expect(pfolder.expanded_path).to eq(p)
    end
  end
  
  #relative_folder
  describe "#relative_folder" do
    it { expect(p).to respond_to :relative_folder }
    context "avec un path relatif (commençant par un '.')" do
      it "retourne la bonne valeur" do
        p = SuperFile::new './tmp/mon/fichier.com'
        point = File.expand_path('.')
        expect(p.relative_folder).to eq(point)
      end
    end
  end
  
  #path_affixe
  describe "#path_affixe" do
    it { expect(p).to respond_to :path_affixe }
    it { expect(p.path_affixe).to eq((p.folder + "fichiertest").to_s) }
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
  
  #path_affixe
  describe "#path_affixe" do
    it { expect(pfile).to respond_to :path_affixe }
    it { expect(pfile.path_affixe).to be_instance_of String }
    context "avec un fichier avec extension" do
      it "retourne le path avec affixe" do
        prov = pfoldertmp + 'un/fichier_affixe.mov'
        expect(prov.path_affixe).to eq('./tmp/un/fichier_affixe')
      end
    end
    context "avec un fichier sans extension" do
      it "retourne le même path" do
        prov = pfoldertmp + 'un/fichier_affixe_sans_ext'
        expect(prov.path_affixe).to eq(prov.path)
      end
    end
  end
  
  #zip_path
  describe "#zip_path" do
    it { expect(pfolder).to respond_to :zip_path }
    it {  expect(pfolder.zip_path).to be_instance_of ::SuperFile }
    it { expect(pfolder.zip_path.to_s).to eq('./tmp.zip') }
  end
  
  #html_path
  describe "#html_path" do
    it { expect(pfile).to respond_to :html_path }
    it { expect(pfile.html_path).to be_instance_of ::SuperFile }
    it "retourne une instance SuperFile du bon path" do
      prov = pfoldertmp + "mon/fichier/texte.txt"
      expect( prov.html_path.path ).to eq('./tmp/mon/fichier/texte.html')
    end
  end
  
  # ---------------------------------------------------------------------
  #
  #   Opérations sur les path
  #
  # ---------------------------------------------------------------------
  
  #+
  describe "#+" do
    it { expect(p).to respond_to :+ }
    context "avec une seule opération +" do
      it "retourne une instance SuperFile" do
        res = pfolder + "sousdossier"
        expect(res).to be_instance_of SuperFile
      end
      it "avec le bon path" do
        res = pfolder + "soufolder"
        expect(res.path).to eq("./tmp/soufolder")
        expect(res.to_s).to eq("./tmp/soufolder")
      end
    end
    context "avec plusieurs opération +" do
      it "retourne une instance SuperFile" do
        expect(pfolder + "sous" + "dossier").to be_instance_of SuperFile
      end
      it "avec le bon path" do
        res = pfolder + "sous" + "dossier"
        expect(res.path).to eq("./tmp/sous/dossier")
      end
    end
    context "+ entre deux instances SuperFile" do
      it "retourne une instance SuperFile" do
        expect(pfolder + pfile).to be_instance_of SuperFile
      end
      it "avec le bon path" do
        res = pfolder + pfile
        expect(res.to_s).to eq(File.join(pfolder, pfile))
      end
    end
  end
  
  #-
  describe "#-" do
    it { expect(pfile).to respond_to :- }
    context "avec un argument appartenant à la hiérarchie du SuperFile" do
      before :all do
        @prov = mytest.pfoldertmp + 'dans/un/dossier/lefichier.txt'
      end
      context "avec l'argument au bout du path" do
        it { expect(@prov - 'dossier/lefichier.txt').to be_instance_of SuperFile }
        it "renvoie le sous-dossier correspondant" do
          res = @prov - 'dossier/lefichier.txt'
          expect(res.path).to eq('./tmp/dans/un')
        end
      end
      context "avec l'argument au début du path" do
        context "en path relatif" do
          it { expect(@prov - './tmp/dans/un').to be_instance_of SuperFile }
          it "retourne le path relatif" do
            expect((@prov - './tmp/dans/un').path).to eq('dossier/lefichier.txt')
          end
        end
        context "en path absolu" do
          before :all do
            @abspath = File.expand_path('./tmp/dans/un')
          end
          it { expect(@prov - @abspath).to be_instance_of SuperFile }
          it "retourne le bon path relatif" do
            expect((@prov - @abspath).path).to eq('dossier/lefichier.txt')
          end
        end
      end
    end
    context "avec un argument qui correspond à l'intérieur du path" do
      before :all do
        @prov = mytest.pfoldertmp + 'dans/un/dossier/lefichier.txt'
        @sup  = 'dans/un/dossier'
      end
      it { expect(@prov - @sup).to eq(nil) }
    end
    context "avec un argument n'appartenant pas à la hiérarchie" do
      before :all do
        @prov = mytest.pfoldertmp + 'dans/un/dos/fichier.rb'
      end
      it { expect(@prov - 'autre/dos/fichier').to eq(nil) }
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
  
end
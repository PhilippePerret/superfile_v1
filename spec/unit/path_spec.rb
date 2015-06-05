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
end
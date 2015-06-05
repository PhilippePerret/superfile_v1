describe "Download d'un fichier SuperFile" do

  lets_in_describe
  
  before :all do
    @pfolderd     = mytest.pfoldertmp + "le/p/folder"
    @pdownloaded  = @pfolderd + 'le/fichier/a_zipper.txt'
    @pdownloaded.write "Contenu du fichier à zipper"
  end
  let(:pfolderd)    { @pfolderd }
  let(:pdownloaded) { @pdownloaded }

  after :all do
    @pfolderd.remove if @pfolderd.exist?
    @pfolderd.zip_path.remove if @pfolderd.zip_path.exist?
  end
  
  describe "#download" do
    it { expect(pdownloaded).to respond_to :download }
    it { expect(pfolderd).to respond_to :download } 

    context "avec un fichier" do
      before :all do
        @tmpoutput = SuperFile::new "./tmpoutput"
        # $stdout.flush
        
        ##
        ## Malheureusement, ça ne fonctionne pas comme ça,
        ## donc je ne sais pas récupérer le retour de la
        ## méthode pour contraire l'header
        ##
        fd = IO.sysopen(@tmpoutput.path, "wb")
        $stdout = IO.new( fd ,"wb")
        # --- Test ici
        expect{ @resultat = @pdownloaded.download }.to_not raise_error
        # ---
        $stdout.flush
        @output = @tmpoutput.read
        $stdout = STDOUT
        @tmpoutput.remove
      end
      after :all do
        @tmpoutput.remove if @tmpoutput.exist?
      end
      it { expect(@resultat).to eq(true) }
      it { expect(pdownloaded.zip_path).to_not be_exist }
      
      # TODO: JE N'ARRIVE PAS À TESTER ÇA…
      # it "produit l'header correct" do
      #   expect(@output).to include "Content-type: application/zip"
      # end
    end
    context "avec un dossier" do
      it "retourne true" do
        expect(pfolderd.download).to eq(true)
      end
      it "détruit le fichier zip en fin de processus" do
        expect(pfolderd.zip_path).to_not be_exist
      end
    end
  end
end
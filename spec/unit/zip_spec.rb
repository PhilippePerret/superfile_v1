describe "Méthode SuperFile#zip" do
  
  lets_in_describe

  after :all do
    mytest.pfolder.remove if mytest.pfolder.exist?
    mytest.pfolder.zip_path.remove if mytest.pfolder.zip_path.exist?
  end
  
  #zip
  describe "#zip (sans paramètres)" do
    context "avec un dossier" do
      before :all do
        mytest.pfolder.zip_path.remove if mytest.pfolder.zip_path.exist?
      end
      it { expect(pfolder).to respond_to :zip }
      it "produit le fichier zippé" do
        expect(pfolder.zip_path).to_not be_exist
        res = pfolder.zip
        expect(res).to eq(true)
        expect(pfolder.zip_path).to be_exist
      end
    end
    context "avec un fichier" do
      before :all do
        mytest.pfile.zip_path.remove if mytest.pfile.zip_path.exist?
      end
      it { expect(pfile).to respond_to :zip }
      it "produit le fichier zippé" do
        expect(pfile.zip_path).to_not be_exist
        res = pfile.zip
        expect(res).to eq(true)
        expect(pfile.zip_path).to be_exist
      end
    end
  end
  
  
  describe "#zip avec un paramètre {Hash}" do
    context "avec un autre path pour le fichier final" do
      before :all do
        mytest.pfile.zip_path.remove if mytest.pfile.zip_path.exist?
        @final_zip = SuperFile::new("./finalzip.zip")
        mytest.pfile.zip( :filename => @final_zip )
      end
      after :all do
        mytest.pfile.zip_path.remove if mytest.pfile.zip_path.exist?
        @final_zip.remove if @final_zip.exist?
      end
      it { expect(pfile.zip_path).to_not be_exist }
      it { expect(@final_zip).to be_exist }
    end
  end
end
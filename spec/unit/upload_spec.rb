=begin

Test de l'upload d'un fichier fourni par un user, par exemple à l'aide 
d'un formulaire

=end
describe "Upload d'un fichier" do
  
  before :all do
    @pfile = mytest.pfoldertmp + "asup.txt"
  end
  after :all do
    mytest.pfoldertmp.remove if mytest.pfoldertmp.exist?
  end
  
  let(:pfile) { @pfile }
  
  #upload  
  describe "#upload" do
    it { expect(pfile).to respond_to :upload }
    context "sans argument" do
      it { expect{ pfile.upload }.to raise_error ArgumentError }
    end
    context "avec un argument qui n'est ni un StringIO ni un symbole ou un string" do
      it "produit une erreur d'argument qui retourne le bon message" do
        [1, {un: 'hash'}, ['un', 'array'], Symbol, 1.0].each do |typ|
          expect{pfile.upload typ}.to raise_error ArgumentError, "L'argument envoyé à SuperFile#upload doit être le fichier StringIO. Impossible d'uploader le fichier"
        end
      end
    end
    
    context "avec des arguments valides" do
      before :all do
        # On crée un fichier original à uploader
        @noriginal = "monfichiera#{Time.now.to_i}.txt"
        @poriginal = mytest.pfoldertmp + 'test-uploadable' + @noriginal
        @texte_in_original = "Ceci est un texte marqué à #{Time.now}"
        @poriginal.write @texte_in_original
      
        # @original_stringio = StringIO.new(@poriginal.expanded_path)
        # expect(@original_stringio).to be_instance_of StringIO
      end
      context "avec un argument qui est un StringIO" do
        before :all do
          @original_stringio = Rack::Test::UploadedFile.new(@poriginal.expanded_path)
          @folder_uploaded = mytest.pfoldertmp + 'test-uploaded'
          @uploaded_file = @folder_uploaded + 'fichierfinal.prov'
          # --- Test
          @uploaded_file_original_name = @folder_uploaded + @noriginal
          # --- / Test
          @resultat = @uploaded_file.upload @original_stringio
        end
        after :all do
          @uploaded_file.remove if @uploaded_file.exist?
          @uploaded_file_original_name.remove if @uploaded_file_original_name.exist?
        end
        it "upload le fichier avec succès" do
          expect(@resultat).to eq(true)
          expect(@uploaded_file_original_name).to be_exist
        end
        it "avec le bon code" do
          expect(@uploaded_file_original_name.read).to eq(@texte_in_original)
        end
        it "en modifiant son nom" do
          expect(@uploaded_file.name).to eq(@noriginal)
        end
      end
      
      context "avec un argument StringIO et les paramètres interdisant la modification de nom de fichier" do
        before :all do
          @original_stringio = Rack::Test::UploadedFile.new(@poriginal.expanded_path)
          @folder_uploaded = mytest.pfoldertmp + 'test-uploaded'
          @uploaded_name = 'fichierfinal.prov'
          @uploaded_file = @folder_uploaded + @uploaded_name
          @uploaded_file_original_name = @folder_uploaded + @noriginal
          @resultat = @uploaded_file.upload( @original_stringio, {change_name: false})
        end
        after :all do
          @uploaded_file.remove if @uploaded_file.exist?
          @uploaded_file_original_name.remove if @uploaded_file_original_name.exist?
        end
        it "upload le fichier avec succès" do
          expect(@resultat).to eq(true)
          expect(@uploaded_file).to be_exist
        end
        it "avec le bon code" do
          expect(@uploaded_file.read).to eq(@texte_in_original)
        end
        it "sans modifier le nom du superfile" do
          expect(@uploaded_file.name).to_not eq( @noriginal )
          expect(@uploaded_file.name).to eq(@uploaded_name)
        end
      end
    
    end # arguments valides
  end
end
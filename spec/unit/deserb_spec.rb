describe "SuperFile#deserb" do
  
  before :all do
    @f = SuperFile::new "./_page/une_page_test.erb"
  end
  
  let(:f) { @f }
  
  describe "Méthode #deserb" do
    it { expect(f).to respond_to :deserb }
    context "avec un fichier contenant un simple texte" do
      before :all do
        @f.write "<%= 'Ceci n’est pas de l’herbe' %>"
      end
      it { expect(f.deserb).to eq("Ceci n’est pas de l’herbe") }
    end
    context "avec un fichier qui n'est pas un fichier ERB" do
      before :all do
        @not_erb = SuperFile::new './_page/une_page.html'
        @not_erb.write "<html></html>"
      end
      it { expect{@not_erb.deserb}.to raise_error RuntimeError, "Ce fichier n'est pas un fichier ERB." }
    end
    context "avec un fichier contenant un code erroné" do
      before :all do
        @f.write "<%= bad %>"
      end
      it { expect{@f.deserb}.to raise_error }
    end
    
    context "avec un objet bindé au fichier erb" do
      before :all do
        class TTUser
          def prenom; "Phil" end
          def nom; "Perret" end
          def mail; "phil@atelier-icare.net" end
        end
        @user = TTUser::new
        @f.write "Je m'appelle <%= prenom %> <%= nom %> et mon mail est <%= mail %>."
      end
      context "sans binding" do
        it { expect { @f.deserb @user }.to raise_error }        
      end
      context "avec binding" do
        before :all do
          class TTUser
            def bind; binding() end
          end
        end
        it { expect { @f.deserb @user }.to_not raise_error }
        it { expect(@f.deserb @user).to eq("Je m'appelle Phil Perret et mon mail est phil@atelier-icare.net.") }
      end
    end
  end
end
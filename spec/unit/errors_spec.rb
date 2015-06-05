describe "Gestion des erreurs" do
  
  lets_in_describe
  
  #errors
  describe "#errors" do
    it { expect(p).to respond_to :errors }
    it "est nil par défaut" do
      prov = SuperFile::new pfolder
      expect(prov.errors).to be_nil
    end
    it "est un array quand une erreur est définie" do
      prov = SuperFile::new pfile
      expect(prov.errors).to eq(nil)
      prov.add_error "Une erreur"
      expect(prov.errors).to_not eq(nil)
      expect(prov.errors).to be_instance_of Array
    end
  end
  
  #add_error
  describe "#add_error" do
    it { expect(p).to respond_to :add_error }
    it "ajoute une erreur" do
      p.errors = nil
      err = "Une erreur #{Time.now.to_i}"
      p.add_error err
      expect(p.errors).to_not eq(nil)
      expect(p.errors).to include err
    end
  end
  
end

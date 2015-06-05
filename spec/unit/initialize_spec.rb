# Instanciation
describe "instanciation des SuperFile" do
  
  lets_in_describe
  
  context "sans argument" do
    it { expect{SuperFile::new}.to raise_error ArgumentError }
  end
  context "avec un argument String" do
    before :each do
      @res = SuperFile::new("./mon/path")
    end
    it { expect(@res).to be_instance_of SuperFile }
    it { expect(@res.path).to eq("./mon/path") }
  end
  context "avec un array" do
    before :each do
      @res = SuperFile::new ['.', 'deux', 'trois.txt']
    end
    it { expect{SuperFile::new ['.', 'deux', 'trois.txt']}.to_not raise_error }
    it { expect(@res).to be_instance_of SuperFile }
    it "avec le bon path" do
      expect(@res.path).to eq("./deux/trois.txt")
    end
  end
  
  context "avec un argument SuperFile" do
    before :all do
      @prov = SuperFile::new mytest.pfolder
    end
    it { expect{SuperFile::new pfolder }.to_not raise_error }
    it { expect(@prov).to be_instance_of SuperFile }
    it { expect(@prov.path).to be_instance_of String }
  end
  
  context "avec une autre valeur qu'un String, un Array ou un SuperFile" do
    it "produit une erreur d'argument" do
      [true, 12, {un: "objet"}, String, nil].each do |type|
        expect{SuperFile::new type}.to raise_error ArgumentError
      end
    end
  end
end


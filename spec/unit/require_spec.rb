describe "Méthode SuperFile#require", focus: true do
  
  lets_in_describe
  
  # Méthode qui retourne un nom de classe original pour les
  # tests courants
  def new_class_name prefix = "Class"
    $classes_courantes ||= {nil => true}
    
    class_name  = "Test#{prefix}Class1"
    iloop       = 1
    class_name = "Test#{prefix}Class#{iloop += 1}" while $classes_courantes.has_key? class_name
    $classes_courantes.merge! class_name => true
    class_name
  end
  
  def classes_are_not_defined
    expect(Object.constants).to_not include @root_class_name.to_sym
    expect(Object.constants).to_not include @sub_class_name.to_sym
    expect(Object.constants).to_not include @subsub_class_name.to_sym
  end
  def expect_root_class_defined defined = true
    if defined
      expect(Object.constants).to include @root_class_name.to_sym
    else
      expect(Object.constants).not_to include @root_class_name.to_sym
    end
  end
  def expect_sub_class_defined defined = true
    if defined
      expect(Object.constants).to include @sub_class_name.to_sym
    else
      expect(Object.constants).not_to include @sub_class_name.to_sym
    end
  end
  def expect_subsub_class_defined defined = true
    if defined
      expect(Object.constants).to include @subsub_class_name.to_sym
    else
      expect(Object.constants).not_to include @subsub_class_name.to_sym
    end
  end
  
  before :each do
    $imainfolder ||= 0
    @main_folder        = mytest.pfoldertmp + "freq#{$imainfolder += 1}"
    # STDOUT.puts "@main_folder créé : #{@main_folder}"
    @submain_folder     = @main_folder + "subfolder"
    @root_class_file    = @main_folder + "root.rb"
    @sub_class_file     = @submain_folder + "sub.rb"
    @subsubmain_folder  = @submain_folder + "subsubfolder"
    @subsub_class_file  = @subsubmain_folder + "subsub_file.rb"
 
    @root_class_name  = new_class_name 'Root'
    @sub_class_name   = new_class_name 'Sub'
    @subsub_class_name  = new_class_name 'SubSub'
 
    @root_class_file.write "class #{@root_class_name}; end"
    @sub_class_file.write "class #{@sub_class_name}; end"
    @subsub_class_file.write "class #{@subsub_class_name}; end"
  end
  after :each do
    @main_folder.remove if @main_folder.exist?
  end
  
  context "sans argument (:deep defaut à true)" do
    it "requiert tout le dossier voulu" do
      classes_are_not_defined
      @main_folder.require
      expect_root_class_defined
      expect_sub_class_defined
      expect_subsub_class_defined
    end
  end
  
  context "avec un argument (paramètres)" do
    context "qui définit :deep à true" do
      it "requiert tout le dossier et les sous-dossiers" do
        classes_are_not_defined
        @main_folder.require deep: true
        expect_root_class_defined   true
        expect_sub_class_defined    true
        expect_subsub_class_defined true
      end
    end
    context "qui définit :deep à false" do
      it "requiert seulement la racine" do
        classes_are_not_defined
        @main_folder.require deep: false
        expect_root_class_defined   true
        expect_sub_class_defined    false
        expect_subsub_class_defined false
      end
    end
    context "qui définit :only" do
      
      context "à un sous-dossier" do
        context "sans définition de :deep" do
          it "charge ce sous-dossier et ses sous-dossiers" do
            classes_are_not_defined
            @main_folder.require only: 'subfolder'
            expect_root_class_defined   false
            expect_sub_class_defined    true
            expect_subsub_class_defined true
          end
        end
        context "avec deep: à false" do
          it "ne charge que les fichiers racine de ce dossier" do
            classes_are_not_defined
            @main_folder.require only: 'subfolder', deep: false
            expect_root_class_defined   false
            expect_sub_class_defined    true
            expect_subsub_class_defined false
          end
        end
      end
      
      context "à :root" do
        it "ne charge que les fichiers à la racine" do
          classes_are_not_defined
          @main_folder.require only: :root
          expect_root_class_defined   true
          expect_sub_class_defined    false
          expect_subsub_class_defined false
        end
      end
    end
    
  end
  
end
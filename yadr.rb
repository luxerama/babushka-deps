dep 'yadr', :argument, :on => :osx do 
  requires 'luxerama:ack.managed',
    'luxerama:ctags.managed',
    'luxerama:git.managed',
    'luxerama:macvim.managed',
    'luxerama:hub.managed',
    'luxerama:prezto'

  path = "#{ENV['HOME']}/.yadr"

  met? { false } #path.p.exist? }

  meet do
    system "git clone https://github.com/skwp/dotfiles #{path}"
    # rake install has to be called after cd to make sure ENV[PWD]
    # points to the correct .yadr dir. Using babushka's cd cmd would
    # not set the ENV[PWD] value to the dir cd'ed into
    # system "cd #{path} && rake install"
  end

  after do
    system "rm -rf #{path}/custom" if "#{path}/custom".p.exist?
    custom_repo ||= get_value "Please specigy your yadr custom repository:"
    system "git clone https://github.com/luxerama/yadr-customisations.git #{path}/custom"
    cd "#{path}/custom" do |custom_path|
      Dir["#{custom_path}/vim/vimrc.{before,after}"].each do |vimrc_path|
        target_path = "~/.#{File.basename vimrc_path}"
        if target_path.p.exist?
          shell "unlink #{target_path}" if confirm "#{target_path} exists, overwrite?"
        end
        system "ln -s #{vimrc_path} $tar" 
      end
    end
  end
end

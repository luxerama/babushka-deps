dep 'yadr', :argument, :on => :osx do 
  requires 'ack.managed', 'ctags.managed', 'git.managed', 'macvim.managed', 'hub.managed', 'prezto'

  path = "#{ENV['HOME']}/.yadri"

  met? { path.p.exist? }

  meet do
    system "git clone https://github.com/skwp/dotfiles ~/.yadri"
    cd path do
      system "rake install"
    end
  end

  after do
    if "#{path}/custom".p.exist?
      system "rm -rf #{path}/custom"
    end
    system "git clone https://github.com/luxerama/yadr-customisations.git #{path}/custom"
    cd "#{path}/custom" do |custom_path|
      Dir["#{custom_path}/vim/vimrc.{before,after}"].each do |vimrc_path|
        system "ln -s #{vimrc_path} ~/.#{File.basename vimrc_path}"
      end
    end
  end
end

dep 'yadr', :argument, :on => :osx do 
  requires 'luxerama:ack.managed',
    'luxerama:ctags.managed',
    'luxerama:git.managed',
    'luxerama:macvim.managed',
    'luxerama:hub.managed',
    'luxerama:prezto'

  path = "#{ENV['HOME']}/.yadr"

  met? { path.p.exist? }

  meet do
    system "git clone https://github.com/skwp/dotfiles #{path}"
    # rake install has to be called after cd to make sure ENV[PWD]
    # points to the correct .yadr dir. Using babushka's cd cmd would
    # not set the ENV[PWD] value to the dir cd'ed into
    system "cd #{path} && rake install"
  end

  after do
    custom_repo ||= Babushka::Prompt.get_value "Please specify your yadr custom repository (optional)", { :prompt => ":"}, &Proc.new { |value|
      log_shell "Removing default custom directory", "rm -rf #{path}/custom" if "#{path}/custom".p.exist?
      begin
        shell! "git clone #{value} #{path}/custom"
      rescue Exception
        false
      end
    }
    if "#{path}/custom".p.exist?
      cd "#{path}/custom" do |custom_path|
        Dir["#{custom_path}/vim/vimrc.{before,after}"].each do |vimrc_path|
          target_path = "~/.#{File.basename vimrc_path}"
          if target_path.p.exist?
            shell "unlink #{target_path}" if confirm "#{target_path} exists, overwrite?"
          end
          log_shell "Linking vim config to #{target_path}", "ln -s #{vimrc_path} #{target_path}"
        end
      end
    end
  end
end

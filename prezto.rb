dep 'prezto', :argument do 
  # requires 'xcode tools'
  met? { "~/.oh-my-zsh".p.exists? }
  meet do
    shell "git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.oh-my-zsh"
    Dir["#{ENV['HOME']}/.oh-my-zsh/runcoms/z{shenv,shrc,login,logout}"].each do |path|
      shell "cp -f #{path} #{ENV['HOME']}/.#{File.basename path}"
    end
    shell "chsh -s /bin/zsh"
    #shell "chmod ugo-x /usr/libexec/path_helper" if host.osx?
  end
end

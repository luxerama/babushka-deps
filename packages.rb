dep 'ack.managed'

dep 'ctags.managed' do
  after :on => :osx do
    if which "ctags" != "/usr/local/bin/ctags"
      ctags_path = "/usr/bin/ctags"
      shell "mv #{ctags_path} /usr/bin/ctags_original", :sudo => !"/usr/bin/ctags_original".p.writable?
    end
  end
end

dep 'git.managed'

dep 'hub.managed'

dep 'macvim.managed' do
  met? :on => :osx do
    "~/Applications/MacVim.app".p.exist?
  end

  after :on => :osx do
    system "brew linkapps macvim"
  end
end


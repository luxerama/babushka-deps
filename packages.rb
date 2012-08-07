dep 'ack.managed'

dep 'ctags.managed' do
  after :on => :osx do
    if which "ctags" != "/usr/local/bin/ctags"
      ctags_path = "/usr/bin/ctags"
      orig_ctags_path = "/usr/bin/ctags_original"
      shell "mv #{ctags_path} #{orig_ctags_path}", :sudo => (!ctags_path.p.writable? || !orig_ctags_path.p.writable?)
    end
  end
end

dep 'git.managed'

dep 'hub.managed'

dep 'macvim.managed', :on => :osx do
  met? do
    "~/Applications/MacVim.app".p.exist?
  end

  after do
    system "brew linkapps macvim"
  end
end


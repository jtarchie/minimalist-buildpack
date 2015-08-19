require "go/buildpack/version"
require 'bdk/recipe'

module BDK::Recipes
  recipe :go do
    detect do |build_dir|
      Dir.chdir(build_dir) do
        Dir['**/*.go'].any?
      end
    end

    compile do |build_dir|
      Dir.chdir(build_dir) do
        godeps = JSON.parse(File.read(File.join('Godeps', 'Godeps.json')))
        name, version = godeps['ImportPath'], godeps['GoVersion']

        log "Installing #{version}"
        download "https://storage.googleapis.com/golang/#{version}.linux-amd64.tar.gz",
          :to => '/tmp'
          set_env PATH: '$HOME/bin:$PATH'

          FileUtils.mkdir_p('bin')
          ENV['GOBIN']  = "#{build_dir}/bin"
          ENV['GOROOT'] = '/tmp/go'
          ENV['GOPATH'] = '/tmp/go'
          ENV['PATH']   = "#{ENV['GOROOT']}/bin:#{ENV['PATH']}"

          path = FileUtils.mkdir_p("#{ENV['GOPATH']}/src/#{name}").first
          FileUtils.cp_r(Dir[build_dir + '/*'], path)

          Dir.chdir(path) { run('go get') }
      end
    end
  end
end

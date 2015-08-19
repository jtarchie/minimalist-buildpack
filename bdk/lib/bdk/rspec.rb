module BDK
  module RSpec
    def run(cmd)
      `docker exec test-buildpack bash -c '#{cmd}'`.tap do |output|
        puts output if ENV['DEBUG']
      end
    end

    def bprun(cmd)
      run "cd /tmp/fixtures && source /tmp/fixtures/.profile.d/*.sh && #{cmd}"
    end

    def compile_buildpack(fixture_name)
      %x{
      docker rm -f test-buildpack
      docker run -dit \
        --name test-buildpack \
        -v `pwd`:/buildpack:ro \
        -w /buildpack \
        -e HOME="/tmp/fixtures" \
        -u www-data \
        cloudfoundry/cflinuxfs2 bash
      }
      run("cp -R /buildpack/spec/fixtures/#{fixture_name} /tmp/fixtures")
      @output = run("/buildpack/vendor/bin/compile /tmp/fixtures /tmp/cache 2>&1")
    end
  end
end

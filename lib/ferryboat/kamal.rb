# frozen_string_literal: true

module Ferryboat
  # Wraps Kamal CLI commands for remote execution
  class Kamal
    def initialize(app: nil, reuse: true)
      @app   = app || ENV.fetch("FERRY_SERVICE")
      @reuse = reuse
    end

    # run a raw kamal command
    def run(*args)
      cmd = ["kamal"]
      cmd << "app" << "exec"
      cmd << "--reuse" if @reuse
      cmd << "--app" << @app if @app
      cmd << "--" << "/bin/sh" << "-lc" << %("#{args.join(' ')}")
      sh cmd.join(" ")
    end

    # convenience: docker subcommand
    def docker(*args)
      run("docker", *args)
    end

    private

    def sh(cmd)
      puts "→ #{cmd}"
      system(cmd)
    end
  end
end

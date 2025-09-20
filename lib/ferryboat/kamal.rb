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
      command = ["kamal"]
      command << "app" << "exec"
      command << "--reuse" if @reuse
      command << "--app" << @app if @app
      command << "--" << "/bin/sh" << "-lc" << %("#{args.join(' ')}")
      sh command.join(" ")
    end

    # convenience: docker subcommand
    def docker(*args)
      run("docker", *args)
    end

    private

      def sh(command)
        puts "→ #{command}"
        system(command)
      end
  end
end

# frozen_string_literal: true

require "yaml"

module Ferryboat
  class Config
    attr_reader :env, :service, :image_repo, :domain, :host,
                :provider, :git_url, :git_branch,
                :health_path, :health_timeout, :detect_timeout,
                :auto_backup

    REQUIRED_KEYS = %i[service image_repo domain].freeze

    class << self
      def from_env(env: ENV.fetch("FERRY_ENV", "production"))
        new(
          env:            env,
          service:        ENV.fetch("FERRY_SERVICE", nil),
          image_repo:     ENV.fetch("FERRY_IMAGE",  nil),
          domain:         ENV.fetch("FERRY_DOMAIN", nil),
          host:           ENV.fetch("FERRY_HOST", "localhost"),
          provider:       ENV.fetch("FERRY_PROVIDER", "docker"), # docker|kamal
          git_url:        ENV["GIT_URL"],
          git_branch:     ENV.fetch("GIT_BRANCH", "main"),
          health_path:    ENV.fetch("FERRY_HEALTH_PATH", "/up"),
          health_timeout: Integer(ENV.fetch("FERRY_HEALTH_TIMEOUT", "120")),
          detect_timeout: Integer(ENV.fetch("FERRY_TRAEFIK_DETECT_TIMEOUT", "60")),
          auto_backup:    ENV["FERRY_AUTO_BACKUP"] == "true"
        )
      end

      # Optional YAML loader (keeps env override semantics)
      def from_file(path, env: "production")
        data   = File.exist?(path) ? (YAML.load_file(path) || {}) : {}
        config = data[env] || data[env.to_s] || data[env.to_sym] || {}

        new(
          env:            env,
          service:        ENV["FERRY_SERVICE"]     || config["service"],
          image_repo:     ENV["FERRY_IMAGE"]       || config["image_repo"] || config["docker_registry"],
          domain:         ENV["FERRY_DOMAIN"]      || config["domain"],
          host:           ENV["FERRY_HOST"]        || config["host"] || "localhost",
          provider:       ENV["FERRY_PROVIDER"]    || config["provider"] || "docker",
          git_url:        ENV["GIT_URL"]           || config["git_url"],
          git_branch:     ENV["GIT_BRANCH"]        || config["git_branch"] || "main",
          health_path:    ENV["FERRY_HEALTH_PATH"] || config["health_path"] || "/up",
          health_timeout: Integer(ENV["FERRY_HEALTH_TIMEOUT"] || config["health_timeout"] || 120),
          detect_timeout: Integer(ENV["FERRY_TRAEFIK_DETECT_TIMEOUT"] || config["detect_timeout"] || 60),
          auto_backup:    (ENV["FERRY_AUTO_BACKUP"] || config["auto_backup"]).to_s == "true"
        )
      end
    end

    def initialize(env:, service:, image_repo:, domain:, host:, provider:, git_url:, git_branch:, health_path:, health_timeout:, detect_timeout:, auto_backup:)
      @env, @service, @image_repo, @domain = env, service, image_repo, domain
      @host, @provider = host, provider
      @git_url, @git_branch = git_url, git_branch
      @health_path, @health_timeout, @detect_timeout = health_path, health_timeout, detect_timeout
      @auto_backup = auto_backup
      validate!
    end

    def validate!
      missing = []
      missing << :service     if blank?(service)
      missing << :image_repo  if blank?(image_repo)
      missing << :domain      if blank?(domain)
      raise ArgumentError, "Missing required config: #{missing.join(', ')}" unless missing.empty?
      true
    end

    def provider_runner
      case provider
      when "kamal"  then Ferryboat::Deployer::KamalRunner.new
      when "docker" then Ferryboat::Deployer::DockerRunner.new
      else raise ArgumentError, "Unknown provider: #{provider.inspect}"
      end
    end

    def to_h
      {
        env: env, service: service, image_repo: image_repo, domain: domain,
        host: host, provider: provider, git_url: git_url, git_branch: git_branch,
        health_path: health_path, health_timeout: health_timeout,
        detect_timeout: detect_timeout, auto_backup: auto_backup
      }
    end

    private

    def blank?(v)
      v.nil? || v.to_s.strip.empty?
    end
  end
end

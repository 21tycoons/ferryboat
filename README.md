# Ferryboat ⚓️

**Ferryboat** is a lightweight deployment tool built by **21tycoons** for teams who want **zero-downtime deployments** for marketing/static sites without the complexity of Kubernetes or heavyweight DevOps stacks.  

It’s designed for marketing sites, micro-apps, and fast-moving projects that need **confidence in production** while staying **simple, portable, and developer-friendly**.

---

## ✨ Features

- **Zero-downtime deployments** (blue/green swap, even on a single server)
- **Staging environments baked in**
- **Lightweight backups** of container volumes
- **GitHub integration** for pulling and building images
- **Simple CLI** powered by Thor
- **Config-driven** via `ferryboat.yml`

---

## 📦 Installation

Add to your Gemfile:

```ruby
gem "ferryboat"
```

Or install directly:

```bash
gem install ferryboat
```

---

## 🚀 Usage

### Create a new project

```bash
ferryboat new mysite
cd mysite
```

### Deploy to production (zero downtime)

```bash
ferryboat deploy
```

### Deploy to staging

```bash
ferryboat deploy --staging
```

### Backup before deploy

```bash
ferryboat backup
```

### Restore a backup

```bash
ferryboat restore
```

### View logs

```bash
ferryboat logs
```

---

## ⚙️ Configuration

Example `ferryboat.yml`:

```yaml
production:
  server: 203.0.113.42
  ssh_key: ~/.ssh/myserver
  repo: git@github.com:21tycoons/mysite.git
  docker_registry: 21tycoons/mysite
  domain: mysite.com

staging:
  server: 203.0.113.42
  ssh_key: ~/.ssh/myserver
  repo: git@github.com:21tycoons/mysite.git
  docker_registry: 21tycoons/mysite-staging
  domain: staging.mysite.com
```

Secrets (like Docker or GitHub tokens) should be set as environment variables.

---

## 🛠 Development

After checking out the repo:

```bash
bin/setup
```

Run tests with:

```bash
rake spec
```

Try the interactive console:

```bash
bin/console
```

Release a new version:

```bash
bundle exec rake release
```

---

## 🤝 Contributing

Bug reports and pull requests are welcome at  
👉 [https://github.com/21tycoons/ferryboat](https://github.com/21tycoons/ferryboat)  

---

## 📜 License

Released under the MIT License. See [LICENSE](LICENSE) for details.

---

🚢 **Ferryboat by 21tycoons** — simple, safe deployments without the complexity.

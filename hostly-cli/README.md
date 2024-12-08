# CLI for [Hostly](https://hostly.khulnasoft.com) API

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/khulnasoft/hostly/hostly-cli/main/scripts/install.sh | bash
```

It will install the CLI in `/usr/local/bin/hostly` and the configuration file in `~/.config/hostly/config.json`

> If you are a windows or mac user, please test the installation script and let us know if it works for you.

## Configuration
1. Get a `<token>` from your Hostly dashboard (Cloud or self-hosted) at `/security/api-tokens`

### Cloud

2. Add the token with `hostly instances set token cloud <token>`

### Self-hosted

2. Add the token with `hostly instances add -d <name> <fqdn> <token>`
   
> Replace `<name>` with the name you want to give to the instance.
>
> Replace `<fqdn>` with the fully qualified domain name of your Hostly instance.

Now you can use the CLI with the token you just added.

## Change default instance
You can change the default instance with `hostly instances set default <name>`
## Currently Supported Commands
### Update
- `hostly update` - Update the CLI to the latest version
  
### Instances
- `hostly instances list` - List all instances
- `hostly instances add` - Create a new instance configuration
- `hostly instances remove` - Remove an instance configuration
- `hostly instances get` - Get an instance configuration
- `hostly instances set <default>|<token>` - Set an instance as default or set a token for an instance
- `hostly instances version` - Get the version of the Hostly API for an instance

### Servers
- `hostly servers list` - List all servers
- `hostly servers get` - Get a server
  - `--resources` - Get the resources and their status of a server
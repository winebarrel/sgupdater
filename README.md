# Sgupdater

Sgupdater is a tool to update the permissions CIDR of AWS security group.

Powerd by [Piculet](http://piculet.codenize.tools/)

## Installation

    $ gem install sgupdater

## Usage

```
Commands:
  sgupdater help [COMMAND]                                  # Describe available commands or one specific command
  sgupdater show --from-cidr=FROM_CIDR                      # Show current permissions
  sgupdater update --from-cidr=FROM_CIDR --to-cidr=TO_CIDR  # Update cidr address

Options:
  p, [--profile=PROFILE]                                   # Load credentials by profile name from shared credentials file.
  k, [--access-key-id=ACCESS_KEY_ID]                       # AWS access key id.
  s, [--secret-access-key=SECRET_ACCESS_KEY]               # AWS secret access key.
  r, [--region=REGION]                                     # AWS region.
      [--shared-credentials-path=SHARED_CREDENTIALS_PATH]  # AWS shared credentials path.
  v, [--verbose], [--no-verbose]
```

### Show

    $ sgupdater show --from-cidr 192.0.2.0/24
    (classic)	sg-deadbeaf	webserver	22	22	192.0.2.0/24
    (classic)	sg-deadbeaf	webserver	80	80	192.0.2.0/24
    vpc-deadbeaf	sg-deadbeaf	apiserver	22	22	192.0.2.0/24
    vpc-deadbeaf	sg-deadbeaf	apiserver	443	443	192.0.2.0/24

### Update

    $ sgupdater update --from-cidr 192.0.2.0/24 --to-cidr 198.51.100.0/24
    (classic)	sg-deadbeaf	webserver	22	22	192.0.2.0/24
    (classic)	sg-deadbeaf	webserver	80	80	192.0.2.0/24
    vpc-deadbeaf	sg-deadbeaf	apiserver	22	22	192.0.2.0/24
    vpc-deadbeaf	sg-deadbeaf	apiserver	443	443	192.0.2.0/24
    Update Permission: classic > webserver(ingress) > tcp 22..22
      authorize 198.51.100.0/24
      revoke 192.0.2.0/24
    Update Permission: classic > webserver(ingress) > tcp 80..80
      authorize 198.51.100.0/24
      revoke 192.0.2.0/24
    Update Permission: vpc-deadbeaf > apiserver(ingress) > tcp 22..22
      authorize 198.51.100.0/24
      revoke 192.0.2.0/24
    Update Permission: vpc-deadbeaf > apiserver(ingress) > tcp 443..443
      authorize 198.51.100.0/24
      revoke 192.0.2.0/24
    Update success

    $ sgupdater show --from-cidr 198.51.10.0/24
    (classic)	sg-deadbeaf	webserver	22	22	198.51.100.0/24
    (classic)	sg-deadbeaf	webserver	80	80	198.51.100.0/24
    vpc-deadbeaf	sg-deadbeaf	apiserver	22	22	198.51.10.0/24
    vpc-deadbeaf	sg-deadbeaf	apiserver	443	443	198.51.10.0/24

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec sgupdater` to use the code located in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/muramasa64/sgupdater/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

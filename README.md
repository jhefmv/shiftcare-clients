# README

This project provides a simple Ruby command-line application which offers two commands for searching clients in a given JSON dataset.


## Requirements

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)

## Installation

```
gem install bundler
bundle install
```


## Running commands

### Searching clients

**Search clients by name:**

```
bin/search_clients query --field=name --query=Smith
bin/search_clients query -f name -q Smith
```

**Search clients by email:**

```
bin/search_clients query --field=email --query=smith@
bin/search_clients query -f email -q smith@
```

**Search clients in a JSON file:**

```
bin/search_clients query --field=name|email --query=smith@yahoo.com --file-path=path_to_file.json
bin/search_clients query -f name|email -q smith@yahoo.com -p path_to_file.json
```

### Finding duplicate clients:

**By field:**

```
bin/search_clients duplicates --field=name|email
bin/search_clients duplicates -f name|email
```

**In a given JSON file:**
```
bin/search_clients duplicates --field=<name|email> --file-path=path_to_file.json
bin/search_clients duplicates -f <name|email> -p path_to_file.json
```

## Running tests

[RSpec](https://rspec.info/) tests are available. To run the tests, issue either one of the commands below:

```
rspec
rspec --format=documentation
bundle exec rspec --format=documentation
```

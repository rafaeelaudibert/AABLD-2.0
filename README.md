# :school_satchel: AABLD :school_satchel:

This repository is meant to create the platform to handle the administrative operation
for the Associação dos Acadêmicos Barbosenses de Longa Distância (AABLD), but, in the
future, will be able to be expanded to handle other associations administrative tasks.

> This is a newer version of the https://github.com/rafaeelaudibert/AABLD platform, using a newer Rails version, and going from Bootstrap to Tailwincss

### :floppy_disk: Prerequisites

To have this running your local machine, you only must have a Ruby version >= 2.6.1. Everything else is covered by Docker, which are used to keep your envinroment safe.

- Ruby >= 3.0.0
- Rails >= 7.0.1
- PGAdmin III _(optional, awesome to see inside container database)_

Learn more about [Installing rbenv](https://github.com/rbenv/rbenv), which is pretty useful to manage your ruby versions.  
Learn more about [Installing Rails](https://rubyonrails.org/), which is pretty useful to have in your machine to improve debugging.

### :zap: Getting Started

- Install application requirements listed above
- clone project

```bash
$ git clone https://github.com/rafaeelaudibert/AABLD-2.0.git AABLD
```

- Install gems

```bash
$ cd AABLD
$ bundle install
```

## :whale: Deployment

[Docker](https://www.docker.com/) and [Docker-compose](https://docs.docker.com/compose/) are used to run this app.

**_REMEMBER TO SET CONFIG/.ENV ENVIRONMENT VARIABLES TO REFLECT WHAT YOU WANT TO DO, ESPECIALLY ABOUT DEVELOPMENT/TEST/PRODUCTION ENVIRONMENT_**

To build the AABLD Docker images you should run the following (only needed in the first time you are doing it):

```bash
$ docker-compose build
```

The next times, you just need to run the following. If you want to daemonize it, just append the `-d` flag

```bash
$ docker-compose up
```

In the first time you are running it, you need to configure the database. Be sure your containers are up, and run:

```bash
$ docker-compose exec app rake db:setup
```

It's done! You are ready to find your app running at `localhost:3000` with a database port open in `localhost:5433`

If you want to enter in a container you can run `docker-compose ps` and see what is the name of your container according to `aabld_<name_of_container>_1`. After you only need to run the following, to enter in a bash inside the container, so you are able to run whatever you want:

```bash
$ docker-compose exec <name_of_container> /bin/bash
```

## :capital_abcd: Running the tests

[WIP] Work in Progress. No tests yet, but [RSpec](https://github.com/rspec/rspec-rails) will be used.

## :train: Built With

- [Tailwindcss](https://tailwindcss.com/) - CSS Framework
- [Ruby on Rails](https://rubyonrails.org/) - Ruby Framework for web
- [postgreSQL](https://www.postgresql.org/) - SQL Database
- :heart: @[Carlos Barbosa](http://www.carlosbarbosa.rs.gov.br/) - Brazil

## :muscle: Contributing

We use [Gitmoji](https://gitmoji.carloscuesta.me/) :tada: in our commits, so please follow the guidelines of it.

## :1234: Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## :construction_worker: Author

Built with love by [Rafa Audibert](https://github.com/rafaeelaudibert)

## :globe_with_meridians: Website

This project is live on [https://portal.aabld.com.br](https://portal.aabld.com.br)

## :page_facing_up: License

This project is licensed under the GNU GENERAL PUBLIC LICENSE - see the [LICENSE.md](LICENSE) file for details

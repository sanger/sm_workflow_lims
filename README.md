Sample Management Workflow
==========================

![Ruby Lint and Test](https://github.com/sanger/sm_workflow_lims/workflows/Ruby%20Lint%20and%20Test/badge.svg)

Description
-----------

Small auto-contained LIMS solution with capabilities to:

- Support for linear workflows (no branching)
- Record labware and samples received
- Track the labware progress through the defined workflows


## Getting started (using Docker)

To set up a local development environment in Docker, you have to build a new Docker image for
sm_workflow_lims. start a stack of services that include a mysql database, and reset
this database contents. You can do all together by running the command:

```shell
RESET_DATABASE=true docker-compose up
```

Optionally, if this is not the first time you start the app, you may not want to reset the
database, and you can run this command instead:

```shell
docker-compose up
```

With this we should have started sm_workflow_lims server and all required services. You should be
able to access sm_workflow_lims by going to <http://localhost:3000> and log in with
username and password admin/admin.

**ABOUT LOCAL DEVELOPMENT SETUP** You may want to start only the required services for sm_workflow_lims (server and jobs worker) and use your local version of Mysql
instead of the Docker version, in that case you can start this setup with the
command:

```shell
docker-compose -f docker-compose-dev.yml up
```

**ABOUT RECREATE DOCKER IMAGE** If you ever need to recreate the image built on first start (because you made modifications
to the Dockerfile file) you can run a building process with:

```shell
docker-compose build
```

## Getting started (using native installation)

It is strongly recommended that you use a ruby version manager such as RVM or rbenv to manage the
Ruby version you are using. The ruby version required should be found in `.ruby-version`.

#### rbenv

If you have the [rbenv ruby-build plugin](https://github.com/rbenv/ruby-build) it is as simple as:

`rbenv install`

It will pick up the version from the .ruby-version file automatically

### Automatic setup

To automatically install the required gems, set-up default configuration files, and set up your database run:

```shell
bin/setup
```


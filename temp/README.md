Sample Management Workflow LIMS
================

A simple workflow management system, originally developed for use in Sample Management.


How to start it
===============

1) Generate the web assets:

rake build:assets

2) Start the web server and go to http://localhost:9292

bundle exec puma

How to test
================

rake

Console
================

As with a rails 3 app, ./script/console opens up a console for maintenance and debugging.

Making Changes
================

The file ./app/manifest.rb is used to load the required files for the application. If new files are added, especially if they aren't required elsewhere in the application they must be added to the manifest. The task:

rake generate:manifest

Can be used to update the manifest file automatically.

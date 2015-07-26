README
=======
-------

This is the code repository for the PsychInsight Ltd survey application.

The application is written as a Ruby on Rails application, using Bootstrap for general themes and styling.
  
**(26/07/2015) Sam:** Some of this is information is probably out of date, since it is copied across from the old wiki. Need to go through and update.

------
  

Code Overview
=======
-------

This page gives an overview of the code hierarchy, as it is organised in the filesystem.

The main pages of interest are:

[Controllers](app/controllers)

[Models](app/models)

[Views](app/views)

-------

app
-------

This is probably the most important folder. In particular, it contains:

### app/assets

Locally created assets such as javascript files, stylesheets and images. 
See: [RailsGuide: Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).

### [app/controllers](app/controllers)

Controls page requests and responses. 

See: [RailsGuide: Action Controller Overview](http://guides.rubyonrails.org/action_controller_overview.html).

### app/helpers 
Code snippets to be reused.

### app/mailers 
For generating/sending mail.

See: [RailsGuide: Action Mailer Basics](http://guides.rubyonrails.org/action_mailer_basics.html).

### [app/models](app/models) 
Similar to classes in other programming languages. 

See: [RailsGuide: Active Record Basics](http://guides.rubyonrails.org/active_record_basics.html).

### [app/views](app/views)

Deals with the actual displaying of pages. 

See: [RailsGuide: Layouts and Rendering](http://guides.rubyonrails.org/layouts_and_rendering.html).

-------

bin 
---------

Contains the scripts to run tasks. Does not usually require any modifications.

-------

config 
---------

Also contains the files for migration tasks in /db/migrate. These files are used to make changes to the database structures in a robust way.  

-------

lib 
---------

Used for any shared assets. This includes re-usable code such as tasks (explained in detail below).

Also contains other shared assets, such as javascript files, stylesheets and images. This is not commonly used, since shared assets would be assets used over multiple projects from the same team.

See: [RailsGuide: Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).

### lib/tasks

Additional rake tasks which can be used when setting up the project.

For example, survey_data and fake_answers are currently used to create some basic example survey data for testing purposes.

-------

log 
---------

Log files.

-------

public 
---------

When the rails server is running, this is the only folder which can be directly accessed by clients. As such it contains some of the static pages (unrelated to the application, such as 404.html), and the precompiled assets.

The precompiled assets are probably the most interesting part of this folder.

See: [RailsGuide: Precompiling Assets](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets)

-------

spec 
---------

This folder is used by RSpec - the testing framework used. For example, the folder /spec/models has the files used in testing models. These can be run by ''rspec'', or individually using ''rspec path/to/file''.

-------

test 
---------

The folder for normal Rails testing. Using RSpec instead so can ignore this folder.

-------

tmp 
---------

Temporary files used by the server, such as session information and cached assets.

-------

vendor 
---------

Contains third party assets, such as javascript files, stylesheets and images.

See: [RailsGuide: Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html).


-------

Other Files 
---------

In the root directory there are also a couple of important files:

### Gemfile
This is the list of Ruby packages used in this application. For example,

''gem 'rails', '4.0.3'''

specifies that rails version 4.0.3 should be installed by Ruby. This is the easiest, and the most common way to introduce external functionality into the application. 

It can also be useful to check Gemfile.lock. Since this specifies the currently installed version on the server. If something has stopped working in between git commits, a likely suspect is an upgraded gem. These can be checked with ''git diff Gemfile.lock'', to see if a particular package has updated.
  
  
-------

AUTHORS
=======
-------

Main authors of the project are:

Sam Scott -- <sams@psychinsight.co.uk>  
Dan Gunnell -- <dang@psychinsight.co.uk>


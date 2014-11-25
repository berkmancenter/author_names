Author Names (OAQ - Online Author Questionnaire)
============

Description
-----------

OAQ is a web-based application that enables libraries to share author data
collected by cooperating publishers. The application enables a publisher's
staff to send email queries to authors to gather information such as:
* Names under which an author publishes and any variants to the name
* Biographical information
* Information about other works by the same author

The application stores the information that authors return to publishers.
Library staff can then use OAQ to view the author information and export it
to formats such as CSV, ZIP, and INSI XML.

Libraries can reuse the author information from OAQ when establishing and
updating name-authority records.

Code Repository
---------------

https://github.com/berkmancenter/author_names

User Documentation
------------------

We're in the process of finalizing user documentation, but once it's up this will get updated with a pointer to it.

Requirements
------------

* Ruby 1.9.3 and a bunch of gems included in the Gemfile
* Rails 3.2.11
* A postgresql 9.x database server. Other databases MAY work (e.g. mysql), but they are untested.
* A webserver capable of interfacing with Rails applications. Ideally, apache or nginx with mod_passenger installed.
* Linux or OSX. Linux would be easier.

Setup
-----

* Install requirements (see above)
* Checkout the code
  * `git clone https://github.com/berkmancenter/author_names`
  * `cd author_names`
* Install libraries
  * `bundle install`
* Configure the database
  * `cp config/database.yml.example config/database.yml`
  * Setup a postgres user and update `config/database.yml` accordingly
  * `rake db:create`
  * `rake db:setup`
  * `rake db:migrate`
* Modify "config/initializers/author_names.rb" for your environment
* Run bootstrap rake tasks for test data: 
  * rake authornames:bootstrap:run_all
* Create cron jobs to automatically run rake tasks for sending out notifications: 
  * rake authornames:cron_task:send_queued_emails

Issue Tracker
-------------

We maintain a closed-to-the-public [issue tracker] (https://cyber.law.harvard.edu/projectmanagement/projects/authornames). Any additional issues can be added to the [GitHub issue tracker](https://github.com/berkmancenter/author_names/issues).

To Do
-----

The current to do items can be found within the [issue tracker] (https://cyber.law.harvard.edu/projectmanagement/projects/authornames).

Built With
----------

The generous support of the [Harvard Library
Lab](http://lab.library.harvard.edu/), the [Harvard Library Office for
Scholarly Communication](https://osc.hul.harvard.edu), the [Berkman Center for
Internet &amp; Society](http://cyber.law.harvard.edu) and the [Arcadia
Fund](http://www.arcadiafund.org.uk)

### Technologies

* [Rails](http://rubyonrails.org/)
* [Bootstrap](http://getbootstrap.com/)
* [PostgreSQL](http://www.postgresql.org/)

Contributors
------------

[Anita Patel] (https://github.com/apatel)

License
-------

GPLv2 - See the LICENSE file for more information.

Copyright
---------

Copyright &copy; 2014 President and Fellows of Harvard College

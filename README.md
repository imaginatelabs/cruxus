radial
======
[![Build Status](https://travis-ci.org/imaginatelabs/radial.svg?branch=master)](https://travis-ci.org/imaginatelabs/radial)
[![Join the chat at https://gitter.im/imaginatelabs/radial](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/imaginatelabs/radial?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Software to help you make software!

## Commands

### Start a new feature
Starts a new feature by creating a feature branch.

`rad feature my_new_feature`

### Get latest changes
Gets the latest changes from your main branch and rebases the changes from your feature branch on top. 

`rad latest`

### Code Review 
Submit your feature branch for a code review.

`rad review`

### Land Changes
Land your changes from your feature branch onto the main branch.

`rad land`

### Help
Learn more about rad commands by using help

`rad help`

## Coming soon
### Working with Micro-Services
Manage groups of micro-services projects with the ability to do the following:
 - Setup all your micro-services in one command
 - Get the latest change for all projects.
 - Build and Run all projects.
 - As micro-services change ensure they remain compatible with one another

### GitHub Integration
Utilise many of the great code review features in GitHub
 - Create a pull request with `rad reivew`
 - Use GitHub issues to create feature branches.
 
### Release
Create an increment release versions. 
 
### Got an idea?
Share it on twitter [@ImaginateLabs](https://www.twitter.com/ImaginateLabs) #radial
 
 OR
  
Come chat about it on our [Gitter channel](https://gitter.im/imaginatelabs/radial)

## Setup
1. Clone and checkout `stable` for the latest stable release version from this repository.
   Note: checkout `master` to get the latest changes
2. You will need Ruby-2.1 and Bundler installed
3. Run `bundle install` to get all the gems you need
4. Add radial to your path e.g. 
  `export PATH=$PATH:/path/to/radial/lib`
5. Run `rad` to test installation

Note: Radial requires Ruby 2.1 if you're using rvm or chruby there's a ruby version in the repo that 
will automatically set Ruby to the right version for you!

## Configuration
Curxus can be configured by placing a ".radconf" in the root of your project. 

A basic git project using feature branching will only need to configure the following values. 
```
application: my_application
build:
  cmd: "build_and_test_my_app.sh"

```

### Inherited Configuration
Radial allows configuration inheritance so that you can customize configuration based on your preferences. 
Below is the order in which the radial files inherit their configurations.
```
$RADIAL_HOME/.radconf                           # Default configuration
$SHARED_HOME/.radconf                       # Inherits/Overwrites $RADIAL_HOME/.radconf
$USER_HOME/.radconf                         # Inherits/Overwrites $SHARED_HOME/.radconf
$WORKSPACE_HOME/.radconf                    # Inherits/Overwrites $USER_HOME/.radconf
$WORKSPACE_HOME/sub/dirs/.radconf           # Inherits/Overwrites $WORKSPACE_HOME/.radconf when run in the subdirectory
```

## Extending 
Radial allows you to write extensions to suit your own work flow.

Details coming soon!

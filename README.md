radial
======
[![Build Status](https://travis-ci.org/imaginatelabs/radial.svg?branch=master)](https://travis-ci.org/imaginatelabs/radial)
[![Join the chat at https://gitter.im/imaginatelabs/radial](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/imaginatelabs/radial?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Software to help you make software!

## Commands

### Start a new feature
Starts a new feature by creating a feature branch.

`cx feature my_new_feature`

### Get latest changes
Gets the latest changes from your main branch and rebases the changes from your feature branch on top. 

`cx latest`

### Code Review 
Submit your feature branch for a code review.

`cx review`

### Land Changes
Land your changes from your feature branch onto the main branch.

`cx land`

### Help
Learn more about cx commands by using help

`cx help`

## Coming soon
### Working with Micro-Services
Manage groups of micro-services projects with the ability to do the following:
 - Setup all your micro-services in one command
 - Get the latest change for all projects.
 - Build and Run all projects.
 - As micro-services change ensure they remain compatible with one another

### GitHub Integration
Utilise many of the great code review features in GitHub
 - Create a pull request with `cx reivew`
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
5. Run `cx` to test installation

Note: Radial requires Ruby 2.1 if you're using rvm or chruby there's a ruby version in the repo that 
will automatically set Ruby to the right version for you!

## Configuration
Curxus can be configured by placing a ".cxconf" in the root of your project. 

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
$CX_HOME/.cxconf                           # Default configuration
$SHARED_HOME/.cxconf                       # Inherits/Overwrites $CX_HOME/.cxconf
$USER_HOME/.cxconf                         # Inherits/Overwrites $SHARED_HOME/.cxconf
$WORKSPACE_HOME/.cxconf                    # Inherits/Overwrites $USER_HOME/.cxconf
$WORKSPACE_HOME/sub/dirs/.cxconf           # Inherits/Overwrites $WORKSPACE_HOME/.cxconf when run in the subdirectory
```

## Extending 
Radial allows you to write extensions to suit your own work flow.

Details coming soon!

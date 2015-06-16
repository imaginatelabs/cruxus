cruxus
======

[![Join the chat at https://gitter.im/imaginatelabs/cruxus](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/imaginatelabs/cruxus?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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
Share it on twitter [@ImaginateLabs](https://www.twitter.com/ImaginateLabs) #cruxus

## Configuration
Curxus can be configured by placing a ".cxconf" in the root of your project. 

A basic git project using feature branching will only need to configure the following values. 
```
application: my_application
build:
  cmd: "build_and_test_my_app.sh"

```

### Inherited Configuration
Cruxus allows configuration inheritance so that you can customize configuration based on your preferences. 
Below is the order in which the cruxus files inherit their configurations.
```
$CX_HOME/.cxconf                           # Default configuration
$SHARED_HOME/.cxconf                       # Inherits/Overwrites $CX_HOME/.cxconf
$USER_HOME/.cxconf                         # Inherits/Overwrites $SHARED_HOME/.cxconf
$WORKSPACE_HOME/.cxconf                    # Inherits/Overwrites $USER_HOME/.cxconf
$WORKSPACE_HOME/sub/dirs/.cxconf           # Inherits/Overwrites $WORKSPACE_HOME/.cxconf when run in the subdirectory
```

## Extending 
Cruxus allows you to write extensions to suit your own work flow.

Details coming soon!

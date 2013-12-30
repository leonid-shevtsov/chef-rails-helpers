# Chef Rails helpers

This is a collection of definitions that I use when deploying my own Ruby on Rails applications.

Look for documentation in the definitions' comments.

## Common conventions

RVM is used and installed system-wide.

For an app called `foo` :

* deploy path: `/home/foo/apps/foo`
    - inside is the capistrano-like directory structure
    - `current`
    - `releases`
    - `shared`
* owner: `foo`
* group: `foo`
* database: `foo`

* * * 

(c) 2013 [Leonid Shevtsov](http://leonid.shevtsov.me)

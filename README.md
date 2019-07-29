## About

A Rails engine which adds a simple cms to your rails project.

## Installation

Add the following to your Gemfile:

```ruby
gem 'cms', git: 'git@github.com:sewa/cms.git', branch: 'master'
```

Copy and run migrations:

```ruby
rake cms:install:migrations
rake db:migrate
```

Mount the engine:

```ruby
mount Cms::Engine, at: '/cms'
```

Start the rails server and access the cms with:

```ruby
http://localhost:3000/cms
```

## Howto use

The cms consists of three different types of entities.

* Cms::ContentNode
* Cms::ContentComponent
* Cms::ContentAttribute

In the following section i will give an overview over each of these entities.

### Cms::ContentNode

The engine expects all content nodes to be placed in app/models/content_nodes.
Here is an example:

```ruby
class ExampleNode < Cms::ContentNode

  template 'page'

  child_nodes :all

  use_components :all

  content_group :content do
    content_attribute :heading, :string
    content_attribute :body, :text
    content_attribute :rotator, :image_list
  end

end
```

Let's discuss the class methods:

```ruby
template
```

is used to tell the client which template should be rendered.

```ruby
child_nodes :all
```

tells the engine that this page can have all page types as subnodes.
Other possible values are:

```ruby
child_nodes except: ['ExampleNode', ...]
child_nodes only: ['ExampleNode', ...]
```

If child_nodes is not defined the page can't have any childpages.

The same options you have with use_components:

```ruby
use_components :all
use_components except: ['ExampleComponent', ...]
use_components only: ['ExampleComponent', ...]
```

To define a grouping of attributes use:

```ruby
content_group :content
```

And finally the actual content is defined with:

```ruby
content_attribute :name, :type
```

### Cms::ContentComponent

```ruby
class ExampleComponent < Cms::ContentComponent

  content_attribute :heading, :string
  content_attribute :body, :text
  content_attribute :rotator, :image_list

end
```

### Cms::ContentAttribute

```ruby
class ExampleAttribute < Cms::ContentComponent

  content_type :string

end
```

## Authentication

The cms has no built in authentication.

It uses cancan for authorization, the rest is up to you.

To hook your user into the cms you have to create the initializer config/initializers/cms.rb
and add the following code to it:

```ruby
Cms.user_class = 'Your user class'
Cms.user_roles_attribute = 'your roles method on user'
```

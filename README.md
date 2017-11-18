# refinement_builder

This is a gem which offers a helper method to create refinement-compatible
modules. It's essentially a factory for modules which enables certain functionality
while avoiding boilerplate.

---
## Installation

Install the gem:

    gem install refinement_builder

Require the code:

    require 'refinement_builder'

---
## Usage 1 - _calling `build_refinement`_

There is one method contained here that is accessible in 3 ways:

1. Class method - [`RefinementBuilder.build_refinement`](http://www.rubydoc.info/gems/refinement_builder/RefinementBuilder.build_refinement):

        RefinementBuilder.build_refinement "StringPatch" do
          # ...
        end
2. Mixin

        include RefinementBuilder
        build_refinement "StringPatch" do
          # ...
        end
3. Refinement

        using RefinementBuilder
        build_refinement "StringPatch" do
          # ...
        end

---
## Usage 2 - _defining functions_
As for what goes inside the block - normal methods, basically. These will be added as both instance and class methods (using `module_function`) _as well as_ refinements. Furthermore, the methods will be able to call each other with implicit namespacing from any of these contexts. For example:

        RefinementBuilder.build_refinement "StringPatch" do
          def print_first_5_characters(string=self)
            print first_5_characters(string)
          end
          def first_5_characters(string=self)
            string.slice 0...5
          end
        end

By defaulting the `string` argument to `self`, the methods are usable as String instance methods (using `self` as the receiver instead of an argument) and `StringPatch` static methods (passing the receiver as an argument).

---

## Usage 3 - _using functions_

The `StringPatch` has its methods accessible in the same 3 ways as `RefinementBuilder`

1. Class method:

        StringPatch.print_first_5_characters("hello world")
        # => hello

2. Mixin:

       String.include StringPatch
       "hello world".print_first_5_characters
       # => hello

3. refinement:

       using StringPatch
       "hello world.print_first_5_characters
       # => hello

## Under the hood
Under the hood, what happens is this:

1. A module is defined with the given name and instance method definitions
2. Each of the instance methods is overwritten in such a way that it will delegate to the class method if called from any other scope, and execute the original function body if it's in class method scope. 
3. The instance methods are copied to class methods via `module_function`
3. A refinement is defined with the instance methods.

## Usage 4 - _options_

`refinement_builder` only cares about three arguments (and the block):

1. The name of the module constant to create (e.g. `"StringPatch"` in the above examples).
2. The following keyword arguments:

    1. `namespace: <class/module>` where the module will be created under (defaults to Object)
    2. `refines: <class>` what the refinement will patch. Also defaults to Object.

## Benefits of this approach

The main benefit is the ability to get these multiple usages without writing wrapper functions. Here's a module definition which is about the same as the one created by this factory:

```
 module StringPatch
   def print_first_5_characters(string=self)
     if eql?(StringPatch)
       print first_5_characters(string)
     else
       StringPatch.print_first_5_characters(string)
     end
   end
   def first_5_characters(string=self)
     if eql?(StringPatch)
       string.slice(0...5)
     else
       StringPatch.first_5_characters(string)
     end
   end
   module_function :print_first_5_characters, :first_5_characters
   refine String do
     include StringPatch
   end
 end
```

In my opinion, this is no fun - too much boiler. 

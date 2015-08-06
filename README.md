# MenuKit

A menu and order framework optimized for encoding into barcodes.

# MenuKit Sampler

A `MenuSampler` iOS application is included that demonstrates the core
components of MenuKit. See the [wiki](https://github.com/Blue-Rocket/BRMenu/wiki/MenuSampler)
for more details.


_TODO: this is a work in progress._

# Project Integration

You can integrate MenuKit via [CocoaPods](http://cocoapods.org/).

## via CocoaPods

Install CocoaPods if not already available:

```bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project, and create a file named `Podfile` with
contents similar to this:

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.4'
	pod 'MenuKit', :subspecs => ['Core', 'RestKit', 'AFNetworking', 'UI']

That will pull in the default **Core** subspec in addition to various other
subspecs. You can tweak this list as needed, for example if you don't want
to use the [RestKit][restkit] integration you can
omit the `'RestKit'` subspec.

Install into your project:

``` bash
$ pod install
```
Open your project in Xcode using the **.xcworkspace** file CocoaPods generated.

### CocoaPod subspecs

MenuKit is divided into several CocoaPod components, or subspecs. 

 1. `Core` - this is the default spec if you don't specify anything else. It 
    contains the core domain objects, without any user-interface related code.
    
 2. `UI` - provides various user interface support such as views and view 
    controllers to help build a MenuKit-powered app.
    
 3. `RestKit` - provides integration with JSON object mapping via the [RestKit][restkit]
    project. `MenuKit` only depends on the `RestKit/ObjectMapping` subspec, and as such
    does not pull in the full RestKit stack, such as networking support. This is
    because `MenuKit` integrates with [AFNetworking][afn] **version 2** but RestKit
    networking depends on AFNetworking version 1.
    
 4. `AFNetworking` - provides integration with [AFNetworking][afn] **version 2** to
    support network requests for menu resources.
    

 [restkit]: https://github.com/RestKit/RestKit/
 [afn]: https://github.com/AFNetworking/AFNetworking
 

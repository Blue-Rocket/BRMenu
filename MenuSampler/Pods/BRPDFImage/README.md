BRPDFImage
==========

_The Little `UIImage` Class That Could (draw vector art)_

As an iOS developer, have you ever thought any of the following:

  * I wish there was a way use vector icons (instead of bitmap ones)! 
  * I'm tired of making two PNG icons for every image, to support retina
    images!
  * I don't want to make @4x icons when the new Eagle Eye Retina
    Display comes out!
  * I have all these icons created in [Illustrator, Inkscape, ...] and 
    I'm annoyed that I have to re-render them as PNG files every time I
    make a change!
  * Why is it raining right now?

If you have, then `BRPDFImage` is here to help you, and wash away those
rainy day blues. `BRPDFImage` is a very small extension of `UIImage`
that allows you to use *PDF* artwork anywhere a `UIImage` is needed. The
PDF format can be thought of as just another vector art file format, and
in fact any vector art editing program worth a lick will support saving
PDF files.

Supported OS Versions
---------------------

`BRPDFImage` supports iOS 5+. Yep, our old friend the iPad 1 is still
supported. Keep on goin' on, little iPad 1.

Example use
-----------

Here is an example of how simple it is to use BRPDFImage:

```objc
NSURL *url = [[NSBundle mainBundle] URLForResource:@"sunshine" withExtension:@"pdf"];
UIColor *tintColor = [UIApplication sharedApplication].keyWindow.tintColor;
UIImage *img = [[BRPDFImage alloc] initWithURL:url maximumSize:CGSizeMake(32,32) tintColor:tintColor];
```

This creates a `UIImage` from *sunshine.pdf* in the application's main
bundle. The image will be treated as a mask and opaque pixels will be
tinted the main window's tint color. You can pass a `nil` tint color to
not give it the tinted treatment.

How it works
------------

`BRPDFImage` simply renders the PDF resource into a bitmap image when
you initialize it, which is why you must pass in a desired `CGSize` (or
maximum size) when doing so. From that point on, you basically have a
normal `UIImage` and can treat it as such.

PDF rendering on iOS is pretty fast, but if you're using a lot of
`BRPDFImage`'s in a `UITableView` or `UICollectionView` you might want
to cache the instances for better performance. The **Demo App** included
in the project does just that (see below).

Project Integration
-------------------

Just copy `BRPDFImage.h` and `BRPDFImage.m` into your project. These are
located in the **BRPDFImage/BRPDFImage** directory. You will need to add
the `CoreGraphics.framework` to your build target, if it's not already
included. Easy!

Demo App
--------

The repository also inclues a small iPhone/iPad app that runs on iOS
5.1.1 or later. It will render a `UITableView` (iOS < 6) or a
`UICollectionView` (iOS >= 6) full of some randomly tinted PDF icons.
The icons come courtesy of [Font
Awesome](http://fortawesome.github.io/Font-Awesome/) (thanks, Dave,
you're awesome).

![Demo App](https://raw.github.com/wiki/Blue-Rocket/BRPDFImage/img/brpdfimage-demo.png)

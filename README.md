# Board

## Summary
Board is a test-coded SwiftUI app (an app coded as a result of a test). Board will let you follow a photo blog feed with beautiful and breathtaking photos.

## Dependencies

Board users Swift Package Manager to handle its dependencies, which are:
- Alamofire
- AlamofireNetworkActivityIndicator
- CouchbaseLiteSwift
- CombineExt
- SDWebImageSwiftUI

Some of this dependencies help power some key functionalities of the app and some where chosen based on the requirenments for this test.

## Features
Board will let you scroll through yout photo blog feed. Initially the feed will be fetched from the API and cached in a local database, so, in the event you lost
internet access you can still access your feed (don't worry, we are caching the images as well). Just keep in mind, when doing Pull To Refresh, we actually clear
the local cache and fetch the feed again.

You'll also be able to tap into any photo to se an enlarged version of it. 

*Important*, right now there's an **intentional 5 seconds delay** before presenting data. This is done so you can appreciate the loading screen (c'mon, it's beautiful!).

## Demo
*Sorry for the laggy GIFs, maybe this is so you can really try the app and found out that it isn't that laggy :D*
iPhone | iPad
-------|------
![iPhone Demo][iphone-demo] | ![iPad Demo][ipad-demo]

## Screenshots
### iPhone
Loading | Home | Photo
--------|------|------
![iPhone Loading State][iphone-loading-state] | ![iPhone Normal Home Image][iphone-normal-state] | ![iPhone Fullscreen Photo][iphone-fullscreen-photo]

### iPad
Loading | Home | Photo
--------|------|------
![iPad Loading State][ipad-loading-state] | ![iPad Normal Home Image][ipad-normal-state] | ![iPad Fullscreen Photo][ipad-fullscreen-photo]

[iphone-demo]: https://user-images.githubusercontent.com/9121130/111870021-91223e80-8958-11eb-83e4-df94f0511386.mp4
[iphone-normal-state]: https://user-images.githubusercontent.com/9121130/111870025-98494c80-8958-11eb-96ab-46557ea05b06.png
[iphone-loading-state]: https://user-images.githubusercontent.com/9121130/111870024-97b0b600-8958-11eb-8473-7493712f0294.png
[iphone-fullscreen-photo]: https://user-images.githubusercontent.com/9121130/111870023-97181f80-8958-11eb-9f01-5c518bd6af35.png

[ipad-demo]: https://user-images.githubusercontent.com/9121130/111869969-43a5d180-8958-11eb-9681-90428675a31b.mp4
[ipad-fullscreen-photo]: https://user-images.githubusercontent.com/9121130/111870010-8798d680-8958-11eb-90a2-f36a57d7ec44.png
[ipad-loading-state]: https://user-images.githubusercontent.com/9121130/111870016-8b2c5d80-8958-11eb-81cf-97118b75cbd8.png
[ipad-normal-state]: https://user-images.githubusercontent.com/9121130/111870017-8b2c5d80-8958-11eb-97ce-12e04797273a.png

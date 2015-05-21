# Waymore
Waymore is an iOS application designed to write and share diary with travel routes. Along the way, users can check in interesting places and events, decorate routes with photos. Waymore provides a platform for users to share their travel logs, comment and like others', and recommend new post to their Facebook friends.

# How to run it
+ You should create a facebook app in https://developers.facebook.com/ and replace "FacebookAppID" and "FacebookDisplayName" with the corresponding information you get from facebook.
+ To communicate with the server, you should replace ` self.serverEndPoint = @"";` in DataAccessManager.m with your own server address. The code of our server is in another github repository ( https://github.com/coolpositron/WaymoreServer).
+ To communicate with the S3, you should replace ` self.accessKey = @""; ` and ` self.secret = @""; ` in DataAccessManager.m with your own AWS credential.

# UI 
The UI part is organized by storyboard, you can understand the logic easily by refering to the storyboard.

# Dependencies
+ ImageIO
+ Facebook SDK
+ CoreLocation
+ MapKit
+ AFNetworking
+ AFAmazonS3Manager
+ SDWebImage
+ DejalActivityView
+ SwipeTableView

# Environment
+ Xcode 6.3.1
+ iOS 8

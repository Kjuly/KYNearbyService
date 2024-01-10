# KYNearbyService

A service for nearby discovery and communication.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKjuly%2FKYNearbyService%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Kjuly/KYNearbyService)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKjuly%2FKYNearbyService%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Kjuly/KYNearbyService)  
![macOS][macOS-Badge] ![iOS][iOS-Badge]  
[![SPM][SPM-Badge]][SPM-Link] [![CocoaPods][CocoaPods-Badge]][CocoaPods-Link] [![Carthage][Carthage-Badge]][Carthage-Link]

[macOS-Badge]: https://img.shields.io/badge/macOS-12.0%2B-blue?labelColor=00367A&color=3081D0
[iOS-Badge]: https://img.shields.io/badge/iOS-15.5%2B-blue?labelColor=00367A&color=3081D0

[SPM-Badge]: https://img.shields.io/github/v/tag/Kjuly/KYNearbyService?label=SPM&labelColor=2F4858&color=A8DF8E
[SPM-Link]: https://swiftpackageindex.com/Kjuly/KYNearbyService
[CocoaPods-Badge]: https://img.shields.io/cocoapods/v/KYNearbyService?label=CocoaPods&labelColor=2F4858&color=A8DF8E
[CocoaPods-Link]: https://cocoapods.org/pods/KYNearbyService
[Carthage-Badge]: https://img.shields.io/github/v/tag/Kjuly/KYNearbyService?label=Carthage&labelColor=2F4858&color=A8DF8E
[Carthage-Link]: https://swiftpackageindex.com/Kjuly/KYNearbyService

<div align="center">
<img src="https://raw.githubusercontent.com/Kjuly/preview/main/KYNearbyService/01.png" alt="iPhone Preview" height="360" /> 
<img src="https://raw.githubusercontent.com/Kjuly/preview/main/KYNearbyService/Mac_01.png" alt="Mac Preview" height="360" />
</div>

## Installation

See the following subsections for details on the different installation methods.

- [Swift Package Manager](INSTALLATION.md#swift-package-manager)
- [CocoaPods](INSTALLATION.md#cocoaPods)
- [Carthage](INSTALLATION.md#carthage)
- [Submodule](INSTALLATION.md#submodule)

## Usage

1. Setup KYNearbyService with your service type.

```Swift
KYNearbyService.setup(with: KYNearbyServiceConfiguration(serviceType: "your-service")
```

> [!IMPORTANT]
> Make sure you've provided [NSBonjourServices](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbonjourservices) in your *.plist file.
> 
> ```xml
> <key>NSBonjourServices</key>
> <array>
>   <string>_your-service._tcp</string>
>   <string>_your-service._udp</string>
> </array>
> ```

2. Use the existing `KYNearbyConnectionView` or setup your own one to provide as the connection view. A demo project is available under "[/KYNearbyServiceDemo](KYNearbyServiceDemo)".

3. Observe notifications (`Notification.Name.KYNearbyService.*`) to handle events.

| Notification | When | Notes
| --- | --- | ---
| didUpdatePeerDisplayName | The user changed the display name | The name is provided as `note.object`.
| shouldSendResource      | The user pressed the "SEND" button | The target peer item (KYNearbyPeerModel instance) is provided as `note.object`. And you can use `KYNearbyService.sendResource(for:at:withName:completion:)` to send the resource to the target peer.
| didStartReceivingResource | The service start receiving resource |
| didReceiveResource | The service did receive resource | The details are available in `note.userInfo`. And the file will be saved to `KYNearbyServiceDefaultFolderURL.archives` by default. You can config the destination folder url by `KYNearbyServiceConfiguration`.

e.g.

```Swift
NotificationCenter.default.addObserver(
  self,
  selector: #selector(_handleKYNearbyServiceShouldSendResourceNotification),
  name: .KYNearbyService.shouldSendResource,
  object: nil)
```

## All Peer Status Preview

<div align="center">
<img src="https://raw.githubusercontent.com/Kjuly/preview/main/KYNearbyService/AllPeerStatus.png" alt="iPhone Preview" height="360" /> 
<img src="https://raw.githubusercontent.com/Kjuly/preview/main/KYNearbyService/AllPeerStatusLandscape.png" alt="iPhone Preview" height="260" />
</div>

You can go to the demo project's `KYNearbyServiceDemoApp.init()`, and switch `.none` to `allPeerStatuses` to get a list of all peer statuses:
```swift
KYNearbyService.shared.debug_populateMockPeers(for: .allPeerStatuses)
```




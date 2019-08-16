
# React Native Unity
> *This library aims at utilizing Library exports included in Unity 2019.3 alongside React Native.*


## Requirements

-  [Unity 2019.3.0a3+](https://unity.com/)

-  [React Native 0.60](https://facebook.github.io/react-native/)

- Native Development Tools (Android Studio, XCode, CocoaPods, etc.)
  

## Getting Started (iOS)
1. Clone repository `git clone git@github.com:CGS-Canada/react-native-unity.git`
2. `cd react-native-unity/CGSDemoApp/` and run `npm install`
3. `cd react-native-unity/CGSDemoApp/ios` and `pod install`
4. Open **UnityProject** folder in Unity and [export the project](https://forum.unity.com/threads/integration-unity-as-a-library-in-native-ios-app.685219) to the folder **UnityProject** and save as **ios**.
5. Open the React Native workspace in Xcode ( **CGSDemoApp** -> **ios** -> **CGSDemoApp.xcworkspace** ). Update the signing/indentifier.
6. Update items required for use with **UnityFramework.framework** (these steps are required any time you re-export your ios project from Unity):
     -  Add UnityFramework.framework to Embedded Binaries [What are Embedded Binaries?](https://stackoverflow.com/questions/30173529/what-are-embedded-binaries-in-xcode)
          - add Unity-iPhone/Products/UnityFramework.framework to Embedded Binaries (this will also add as Linked Framework, which we remove next step)
          - remove UnityFramework.framework from Linked Frameworks and Libraries ( select it and press "-" )
     - Select Unity-iPhone / Libraries / Plugins / iOS / NativeCallProxy.h and enable UnityFramework in Target Membership and set Public**
     - Select Unity-iPhone / Data and swap Target Membership to UnityFramework from Unity-iPhone**
7. Lastly, update the metro bundler IP address in **main.mm** `NSURL *jsCodeLocation = [NSURL URLWithString:@"http://<<metro server ip address>>/index.bundle?platform=ios"];` (or swap to local bundle loading of index.js)
     
Your project is now ready to run!

## Getting Started (Android) (*to-do***)
  

## How this Project was Made

> *These steps can be useful in understand how this project was created in order to reproduce your own custom projects.*

  

1. Create a ReactNative (RN) project (this project build with TypeScript template: `react-native init CGSDemoApp --template typescipt`, due to a [temporary issue](https://github.com/react-native-community/cli/issues/595) **Error: Cannot find module ...** the following was used to generate the project: `npx react-native init CGSDemoApp --template react-native-template-typescript@next`). See [package.json](./CGSDemoApp/package.json) for version details.

2. Export Unity as a Library as explained [here](https://forum.unity.com/threads/using-unity-as-a-library-in-native-ios-android-apps.685195/). Step by step guides can be found for [Android](https://forum.unity.com/threads/integration-unity-as-a-library-in-native-android-app.685240/) and [iOS](https://forum.unity.com/threads/integration-unity-as-a-library-in-native-ios-app.685219). If you wish to export your own Unity project, you need to add [plugins](./UnityProject/Assets/Plugins) (2019.3.0a3+ required, this Unity was loaded with 2019.3.0a10). The steps for integration are explained at the links (highly recommended to read through for the extra information), and are briefly covered below.

  

## iOS

### Unity
1. Open Unity project and set platform to iOS.

2. Build your project. This project was saved as [ios](./UnityProject/ios) in the Unity project folder. You can now close Unity.

3. Open your RN ios project workspace and add the [Unity Xcode project](./UnityProject/ios/Unity-iPhone.xcodeproj) to the project using the + on the bottom left of the project structure window (make sure no items are selected in the navigation pane, and the project is added at the top level of the workspace, see [issues regarding adding workspaces](https://stackoverflow.com/questions/11021514/xcode-4-x-adding-new-project-to-a-workspace)).

4. Update items required for use with **UnityFramework.framework** (these steps are required any time you re-export your ios project from Unity):
     -  Add UnityFramework.framework to Embedded Binaries [What are Embedded Binaries?](https://stackoverflow.com/questions/30173529/what-are-embedded-binaries-in-xcode)
          - add Unity-iPhone/Products/UnityFramework.framework to Embedded Binaries (this will also add as Linked Framework, which we remove next step)
          - remove UnityFramework.framework from Linked Frameworks and Libraries ( select it and press "-" )
     - Select Unity-iPhone / Libraries / Plugins / iOS / NativeCallProxy.h and enable UnityFramework in Target Membership and set Public**
     - Select Unity-iPhone / Data and swap Target Membership to UnityFramework from Unity-iPhone**

5. Remove **AppDelegate.h** and **AppDelegate.m** files, rename **main.m** to **main.mm** and swap swap for the provided entrance script written by Unity (found in the Native iOS example).

 6. Add storyboard, with MyViewController set fullscreen in CGSDemoApp project as a requirement (info.plist)

   

### React Native

 - Only a bridge was required to add React Native to the proejct. Please see [React Native - Native Modules](https://facebook.github.io/react-native/docs/native-modules-ios) guide to see how messaging was added from React Native to Native and [React Native - Communcation between native and React Native](https://facebook.github.io/react-native/docs/communication-ios) for Native to React Native prop management.
 - Details may be extended if needed, and comments in code are *to-do*** for being more detailed on the process.

  

## Android

  

### Unity

  

1. Export project

2. Add debug keystore (if needed)


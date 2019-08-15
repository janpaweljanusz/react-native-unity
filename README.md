# React Native Unity
=====
   *This library aims at utilizing Library exports included in Unity 2019.3 alongside React Native.*

## Requirements
-----
 - [Unity 2019.3.0a3+](https://unity.com/)
 - [React Native](https://facebook.github.io/react-native/)
 - Native Tools (Android Studio, XCode, CocoaPods)

## Getting Started
-----

## General Setup

1. Create a ReactNative (RN) project (this project build with TypeScript template: `react-native init CGSDemoApp --template typescipt`, due to a [temporary issue](https://github.com/react-native-community/cli/issues/595) **Error: Cannot find module ...** the following was used to generate the project: `npx react-native init CGSDemoApp --template react-native-template-typescript@next`). See [package.json](./CGSDemoApp/package.json) for version details.
2. Export Unity as a Library as explained [here](https://forum.unity.com/threads/using-unity-as-a-library-in-native-ios-android-apps.685195/). Step by step guides can be found for [Android](https://forum.unity.com/threads/integration-unity-as-a-library-in-native-android-app.685240/) and [iOS](https://forum.unity.com/threads/integration-unity-as-a-library-in-native-ios-app.685219). If you wish to export your own Unity project, you need to add [plugins](./UnityProject/Assets/Plugins) (2019.3.0a3+ required, this Unity was loaded with 2019.3.0a10). The steps for integration are explained at the links (highly recommended to read through for the extra information), and are briefly covered below.

## iOS

### Unity

1. Open Unity project and set platform to iOS. Add Bundle Identifier and Signing Team ID (found in your [developer account](https://developer.apple.com/)).
2. Build your project. This project was saved as (ios)[./UnityProject/ios] in the Unity project folder. You can now close Unity.
3. Open your RN ios project workspace and add the [Unity Xcode project](./UnityProject/ios/Unity-iPhone.xcodeproj) to the project using the + on the bottom left of the project structure window (make sure no items are selected in the navigation pane, and the project is added at the top level of the workspace, see [issues regarding adding workspaces](https://stackoverflow.com/questions/11021514/xcode-4-x-adding-new-project-to-a-workspace)).
4. Add UnityFramework.framework to Embedded Binaries [What are Embedded Binaries?](https://stackoverflow.com/questions/30173529/what-are-embedded-binaries-in-xcode)
     * add Unity-iPhone/Products/UnityFramework.framework to Embedded Binaries (this will also add as Linked Framework, which we remove next step)
     * remove UnityFramework.framework from Linked Frameworks and Libraries ( select it and press - ) 
5. Select Unity-iPhone / Libraries / Plugins / iOS / NativeCallProxy.h and enable UnityFramework in Target Membership and set Public**
6. Select Unity-iPhone / Data and swap Target Membership to UnityFramework from Unity-iPhone**
7. Remove **AppDelegate.h** and **AppDelegate.m** files, rename **main.m** to **main.mm** and swap swap for the provided entrance script written by Unity (found in the Native iOS example).

#### Notes
- \*\*Any time Unity project is updated and exported **5** and **7** need to be repeated
- Fullscreen is preferred, and added the CGSDemoApp project as a requirement

At this point we should have a Native i

### React Native

1. Additional steps coming...

## Android

### Unity

1. Export project
2. Add debug keystore (if needed)
3. 

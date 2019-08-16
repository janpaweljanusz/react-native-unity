// to-do: split out declarations for readability

#import <UIKit/UIKit.h>

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>
  
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

UnityFramework* UnityFrameworkLoad()
{
  NSString* bundlePath = nil;
  bundlePath = [[NSBundle mainBundle] bundlePath];
  bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
  
  NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
  if ([bundle isLoaded] == false) [bundle load];
  
  UnityFramework* ufw = [bundle.principalClass getInstance];
  if (![ufw appController])
  {
    // unity is not initialized
    [ufw setExecuteHeader: &_mh_execute_header];
  }
  return ufw;
}

// used with safeguard for unity bundle dynamic load/unload example (not in use)
//void showAlert(NSString* title, NSString* msg) {
//  UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg                                                         preferredStyle:UIAlertControllerStyleAlert];
//  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction * action) {}];
//  [alert addAction:defaultAction];
//  auto delegate = [[UIApplication sharedApplication] delegate];
//  [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
//}

@interface AppDelegate : UIResponder<UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIButton *reloadBtn;
@property (nonatomic, strong) NSString *cubeColor;
@property (nonatomic, strong) NSDictionary *props;
@property (nonatomic, strong) RCTRootView *rootView;
@property (nonatomic, strong) UIView *unityView;

@property UnityFramework* ufw;
- (void)initRNandUnity;
- (void)sendMsgToUnity:(const char*)color;

- (void)didFinishLaunching:(NSNotification*)notification;
- (void)didBecomeActive:(NSNotification*)notification;
- (void)willResignActive:(NSNotification*)notification;
- (void)didEnterBackground:(NSNotification*)notification;
- (void)willEnterForeground:(NSNotification*)notification;
- (void)willTerminate:(NSNotification*)notification;
- (void)unityDidUnloaded:(NSNotification*)notification;
@end


/////////////////
// GLOBAL VARIABLES
AppDelegate* hostDelegate = NULL;

// keep arg for unity init from non main
int gArgc = 0;
char** gArgv = nullptr;
NSDictionary* appLaunchOpts;
/////////////////


/////////////////
// React Native - Native Module method, called from javascript bundle
@interface RNManager: NSObject <RCTBridgeModule>
@end
@implementation RNManager
- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(reactMessage:(NSString*)color)
{
  NSString *s = color;
  const char *c = [s UTF8String];
  [hostDelegate sendMsgToUnity: c];
}
@end
/////////////////

/////////////////
// Landing view controller (loads from storyboard on initialization), loads both RN and Unity on load
@interface MyViewController : UIViewController
@end
@interface MyViewController ()
@end
@implementation MyViewController
- (void)viewDidLoad
{
  [super viewDidLoad];
  [hostDelegate initRNandUnity];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
@end
/////////////////


/////////////////
// MAIN implementaion
@implementation AppDelegate

- (bool)unityIsInitialized { return [self ufw] && [[self ufw] appController]; }

// unity bundle dynamic load/unload example (not in use)
//- (void)ShowMainView
//{
//  if(![self unityIsInitialized]) {
//    showAlert(@"Unity is not initialized", @"Initialize Unity first");
//  } else {
//    [[self ufw] showUnityWindow];
//  }
//}

// Message received from Unity (update RN props)
- (void)unityMessage:(NSString*)color
{
  NSLog(@"UNITY UPDATE COLOR: %@", color);
  self.props = @{@"cubeColor": [NSString stringWithFormat:@"#%@", color]};
  self.rootView.appProperties = self.props;
}

// Base method to send message from Native to Unity, targets Cube GameObject
- (void)sendMsgToUnity:(const char*)color
{
  [[self ufw] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: color];
  NSString *s = [NSString stringWithUTF8String:color];
  self.props = @{@"cubeColor": s};
  self.rootView.appProperties = self.props;
}

// Method to initialize RN and Unity
- (void)initRNandUnity
{
  /////////////////
  // Unity bundle loading
  if([self unityIsInitialized]) { // safeguard for unity bundle dynamic load/unload example (not in use)
//    showAlert(@"Unity already initialized", @"Unload Unity first");
    return;
  }
  [self setUfw: UnityFrameworkLoad()];
  // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
  // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
  [[self ufw] setDataBundleId: "com.unity3d.framework"];
  [[self ufw] registerFrameworkListener: self];
  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
  [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
  
  self.unityView = [[[self ufw] appController] rootView]; // set view to root
  /////////////////
  
  ////////////////
  // Reload Button - for those who just want a button to reload from the Metro server (uncomment with method below to enable)
//  self.reloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//  [self.reloadBtn setTitle: @"Reload" forState: UIControlStateNormal];
//  self.reloadBtn.frame = CGRectMake(0, 150, 150, 50);
//  self.reloadBtn.backgroundColor = [UIColor whiteColor];
//  [self.reloadBtn addTarget: self action: @selector(reload:) forControlEvents: UIControlEventPrimaryActionTriggered];
//  [self.unityView addSubview: self.reloadBtn];
  ////////////////

  //////////////
  // React View - set bundle location either local or to your host machine's IP address
  // to-do: add example of local bundling alongside dynamic server bundling
  NSURL *jsCodeLocation = [NSURL URLWithString:@"http://192.168.11.191:8081/index.bundle?platform=ios"]; // UPDATE IP ADDRESS HERE, OR SWAP TO LOCAL BUNDLE LOADING
  self.cubeColor = @"green";
  self.props = @{@"cubeColor": self.cubeColor};
  
  self.rootView =
  [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                              moduleName: @"CGSDemoApp"
                       initialProperties: self.props
                           launchOptions: nil];
  self.rootView.frame = CGRectMake(0, self.unityView.frame.size.height - 80, self.unityView.frame.size.width, 80); // React view is set as an overlay, bottom 80 pixels
  self.rootView.backgroundColor = UIColor.clearColor; // transparent view on ios, only items set in react can be seen
  [self.unityView addSubview:self.rootView]; // to-do: adding an animation
  //////////////
}


// Reload Button - for those who just want a button to reload from the Metro server, uncomment with button created above to enable
//- (void)reload:(UIButton *)sender
//{
//  [self.rootView removeFromSuperview];
//  NSURL *jsCodeLocation = [NSURL URLWithString:@"http://192.168.11.191:8081/index.bundle?platform=ios"];
//  self.rootView =
//  [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
//                              moduleName: @"CGSDemoApp"
//                       initialProperties: self.props
//                           launchOptions: nil];
//  self.rootView.frame = CGRectMake(0, self.unityView.frame.size.height - 80, self.unityView.frame.size.width, 80);
//  self.rootView.backgroundColor = UIColor.clearColor;
//  [self.unityView addSubview:self.rootView];
//}


// unity bundle dynamic load/unload example (not in use)
//- (void)unloadButtonTouched:(UIButton *)sender
//{
//  if(![self unityIsInitialized]) {
//    showAlert(@"Unity is not initialized", @"Initialize Unity first");
//  } else {
//    [UnityFrameworkLoad() unloadApplicaion: true];
//  }
//}

// unity bundle dynamic load/unload example (not in use)
//- (void)unityDidUnload:(NSNotification*)notification
//{
//  NSLog(@"unityDidUnloaded called");
//  [[self ufw] unregisterFrameworkListener: self];
//  [self setUfw: nil];
//}

// Main AppDelegate delegates
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  hostDelegate = self;
  return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application { [[[self ufw] appController] applicationWillResignActive: application]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self ufw] appController] applicationDidEnterBackground: application]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self ufw] appController] applicationWillEnterForeground: application]; }
- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self ufw] appController] applicationDidBecomeActive: application]; }
- (void)applicationWillTerminate:(UIApplication *)application { [[[self ufw] appController] applicationWillTerminate: application]; }

@end
/////////////////



/////////////////
// app main
int main(int argc, char* argv[])
{
  gArgc = argc;
  gArgv = argv;
  
  @autoreleasepool
  {
    UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: "AppDelegate"]);
  }
  
  return 0;
}
/////////////////

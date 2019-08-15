#import <UIKit/UIKit.h>

#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTLog.h>
#import <React/RCTBridgeModule.h>

@interface RNManager: NSObject <RCTBridgeModule>
@end

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

void showAlert(NSString* title, NSString* msg) {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:msg                                                         preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
  [alert addAction:defaultAction];
  auto delegate = [[UIApplication sharedApplication] delegate];
  [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
@interface MyViewController : UIViewController
@end

@interface AppDelegate : UIResponder<UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIButton *showUnityOffButton;
@property (nonatomic, strong) UIButton *btnSendMsg;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) UIButton *unloadBtn;
@property (nonatomic, strong) MyViewController *viewController;
@property (nonatomic, strong) NSString *cubeColor;
@property (nonatomic, strong) NSDictionary *props;
@property (nonatomic, strong) RCTRootView *rootView;
@property (nonatomic, strong) UIView *unityView;

@property UnityFramework* ufw;
- (void)initUnity;
- (void)ShowMainView;
- (void)sendMsgToUnity:(const char*)color;
- (void)randomizeColor:(NSString*)color;

- (void)didFinishLaunching:(NSNotification*)notification;
- (void)didBecomeActive:(NSNotification*)notification;
- (void)willResignActive:(NSNotification*)notification;
- (void)didEnterBackground:(NSNotification*)notification;
- (void)willEnterForeground:(NSNotification*)notification;
- (void)willTerminate:(NSNotification*)notification;
- (void)unityDidUnloaded:(NSNotification*)notification;

@property RNManager* rnManager;
- (void)updateColor;
@end

AppDelegate* hostDelegate = NULL;

// -------------------------------
// -------------------------------
// -------------------------------


@interface MyViewController ()
@property (nonatomic, strong) UIButton *unityInitBtn;
@property (nonatomic, strong) UIButton *unpauseBtn;
@property (nonatomic, strong) UIButton *unloadBtn;
@end

@implementation RNManager
- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(reactMessage:(NSString*)color)
{
  RCTLogInfo(@"REACT UPDATE COLOR: %@", color);
  NSString *s = color;
  const char *c = [s UTF8String];
  [hostDelegate sendMsgToUnity: c];
}
@end


@implementation MyViewController
- (void)viewDidLoad
{
  [super viewDidLoad];
  [hostDelegate initUnity];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end


// keep arg for unity init from non main
int gArgc = 0;
char** gArgv = nullptr;
NSDictionary* appLaunchOpts;


@implementation AppDelegate

- (bool)unityIsInitialized { return [self ufw] && [[self ufw] appController]; }

- (void)ShowMainView
{
  if(![self unityIsInitialized]) {
    showAlert(@"Unity is not initialized", @"Initialize Unity first");
  } else {
    [[self ufw] showUnityWindow];
  }
}

- (void)unityMessage:(NSString*)color
{
  NSLog(@"UNITY UPDATE COLOR: %@", color);
  self.props = @{@"cubeColor": [NSString stringWithFormat:@"#%@", color]};
  self.rootView.appProperties = self.props;
}

- (void)sendMsgByButton
{
  NSString *s = @"yellow";
  const char *c = [s UTF8String];
  [self sendMsgToUnity: c];
}

- (void)sendMsgToUnity:(const char*)color
{
  [[self ufw] sendMessageToGOWithName: "Cube" functionName: "ChangeColor" message: color];
  NSString *s = [NSString stringWithUTF8String:color];
  self.props = @{@"cubeColor": s};
  self.rootView.appProperties = self.props;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  hostDelegate = self;
  return YES;
}

- (void)initUnity
{
  if([self unityIsInitialized]) {
    showAlert(@"Unity already initialized", @"Unload Unity first");
    return;
  }
  
  [self setUfw: UnityFrameworkLoad()];
  // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
  // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
  [[self ufw] setDataBundleId: "com.unity3d.framework"];
  [[self ufw] registerFrameworkListener: self];
  [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
  
  [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
  
  self.unityView = [[[self ufw] appController] rootView];
  
  // Reload Button
  self.unloadBtn = [UIButton buttonWithType: UIButtonTypeSystem];
  [self.unloadBtn setTitle: @"Reload" forState: UIControlStateNormal];
  self.unloadBtn.frame = CGRectMake(0, 150, 150, 50);
  self.unloadBtn.backgroundColor = [UIColor whiteColor];
  [self.unloadBtn addTarget: self action: @selector(reload:) forControlEvents: UIControlEventPrimaryActionTriggered];
  [self.unityView addSubview: self.unloadBtn];

  // React View
  NSURL *jsCodeLocation = [NSURL URLWithString:@"http://192.168.11.191:8081/index.bundle?platform=ios"];
  self.cubeColor = @"green";
  self.props = @{@"cubeColor": self.cubeColor};
  
  self.rootView =
  [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                              moduleName: @"CGSDemoApp"
                       initialProperties: self.props
                           launchOptions: nil];
  
  self.rootView.frame = CGRectMake(0, self.unityView.frame.size.height - 80, self.unityView.frame.size.width, 80);
  self.rootView.backgroundColor = UIColor.clearColor;
  [self.unityView addSubview:self.rootView];
  
}

- (void)reload:(UIButton *)sender
{
  [self.rootView removeFromSuperview];
  NSURL *jsCodeLocation = [NSURL URLWithString:@"http://192.168.11.191:8081/index.bundle?platform=ios"];
  self.rootView =
  [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
                              moduleName: @"CGSDemoApp"
                       initialProperties: self.props
                           launchOptions: nil];
  self.rootView.frame = CGRectMake(0, self.unityView.frame.size.height - 80, self.unityView.frame.size.width, 80);
  self.rootView.backgroundColor = UIColor.clearColor;
  [self.unityView addSubview:self.rootView];
}

- (void)unloadButtonTouched:(UIButton *)sender
{
  if(![self unityIsInitialized]) {
    showAlert(@"Unity is not initialized", @"Initialize Unity first");
  } else {
    [UnityFrameworkLoad() unloadApplicaion: true];
  }
}

- (void)unityDidUnload:(NSNotification*)notification
{
  NSLog(@"unityDidUnloaded called");
  
  [[self ufw] unregisterFrameworkListener: self];
  [self setUfw: nil];
  [self randomizeColor:@""];
}

- (void)applicationWillResignActive:(UIApplication *)application { [[[self ufw] appController] applicationWillResignActive: application]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self ufw] appController] applicationDidEnterBackground: application]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self ufw] appController] applicationWillEnterForeground: application]; }
- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self ufw] appController] applicationDidBecomeActive: application]; }
- (void)applicationWillTerminate:(UIApplication *)application { [[[self ufw] appController] applicationWillTerminate: application]; }

@end





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

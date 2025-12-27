#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>

#import "LiveActivities-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"LiveActivities";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];

  if (@available(iOS 16.1, *)) {
      // Önce basit isimle dene
      Class managerClass = NSClassFromString(@"LAActivityManager");
      
      // Swift bazen ModuleName.ClassName şeklinde kayıt eder
      if (!managerClass) {
          managerClass = NSClassFromString(@"LiveActivities.LAActivityManager");
          // Buradaki LiveActivities = app target / module adın
          // Farklıysa kendi module name'ini yaz
      }

      if (managerClass && [managerClass respondsToSelector:@selector(startTestActivity)]) {
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
          [managerClass performSelector:@selector(startTestActivity)];
  #pragma clang diagnostic pop
      } else {
          NSLog(@"❌ LAActivityManager veya startTestActivity bulunamadı");
      }
  }

    return result;
 }

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end


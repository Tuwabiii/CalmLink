class AppAssets {
  // Base asset paths
  static const String _imagesPath = 'assets/images';
  static const String _videosPath = 'assets/videos';
  static const String _iconsPath = 'assets/icons';
  static const String _animationsPath = 'assets/animations';

  // Image assets
  static const String logo = '$_imagesPath/logo.png';
  static const String logoIcon = '$_imagesPath/logo_icon.png';
  static const String calmLinkLogo = '$_imagesPath/CalmLink_Logo.png';
  static const String calmLinkText = '$_imagesPath/CalmLink_Text.png';
  static const String background = '$_imagesPath/background.jpg';
  static const String profilePlaceholder = '$_imagesPath/profile_placeholder.png';
  static const String heartRateBg = '$_imagesPath/heart_rate_bg.png';
  static const String splashScreen = '$_imagesPath/splash_screen.png';
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';

  // Video assets
  static const String introVideo = '$_videosPath/intro_video.mp4';
  static const String meditationGuide = '$_videosPath/meditation_guide.mp4';
  static const String exerciseDemo = '$_videosPath/exercise_demo.mp4';
  static const String tutorialSetup = '$_videosPath/tutorial_setup.mp4';
  static const String healthTips = '$_videosPath/health_tips.mp4';

  // Icon assets
  static const String heartIcon = '$_iconsPath/heart_icon.png';
  static const String settingsIcon = '$_iconsPath/settings_icon.png';
  static const String profileIcon = '$_iconsPath/profile_icon.png';
  static const String notificationIcon = '$_iconsPath/notification_icon.png';
  static const String healthMonitorIcon = '$_iconsPath/health_monitor_icon.png';
  static const String emergencyIcon = '$_iconsPath/emergency_icon.png';

  // Animation assets
  static const String loadingAnimation = '$_animationsPath/loading_animation.json';
  static const String heartPulse = '$_animationsPath/heart_pulse.json';
  static const String successCheckmark = '$_animationsPath/success_checkmark.json';
  static const String errorAnimation = '$_animationsPath/error_animation.json';
  static const String onboardingAnimation = '$_animationsPath/onboarding_animation.json';

  // Helper methods
  static String getImagePath(String imageName) => '$_imagesPath/$imageName';
  static String getVideoPath(String videoName) => '$_videosPath/$videoName';
  static String getIconPath(String iconName) => '$_iconsPath/$iconName';
  static String getAnimationPath(String animationName) => '$_animationsPath/$animationName';
}

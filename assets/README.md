# CalmLink Assets

This folder contains all the static assets used in the CalmLink application.

## Folder Structure

### `/images/`
Contains all image assets used in the app:
- UI background images
- Health monitoring graphics
- Profile pictures
- Illustrations
- Screenshots

**Supported formats:** PNG, JPG, JPEG, GIF, WebP

### `/videos/`
Contains video assets:
- Instructional videos
- Health exercise demonstrations
- Meditation guides
- App tutorials

**Supported formats:** MP4, MOV, AVI, WebM

### `/icons/`
Contains custom icon assets:
- App icons
- Custom UI icons
- Health-related icons
- Navigation icons

**Supported formats:** PNG, SVG, ICO

### `/animations/`
Contains animation assets:
- Lottie animations
- GIF animations
- Loading animations
- Transition animations

**Supported formats:** JSON (Lottie), GIF, WebP

## Usage in Code

To use these assets in your Flutter code:

```dart
// For images
Image.asset('assets/images/your_image.png')

// For videos
VideoPlayerController.asset('assets/videos/your_video.mp4')

// For icons
Image.asset('assets/icons/your_icon.png')

// For animations (if using Lottie)
Lottie.asset('assets/animations/your_animation.json')
```

## Best Practices

1. **File naming**: Use lowercase with underscores (e.g., `heart_rate_icon.png`)
2. **Image optimization**: Compress images to reduce app size
3. **Multiple resolutions**: Provide 1x, 2x, and 3x versions for different screen densities
4. **File formats**: 
   - Use PNG for images with transparency
   - Use JPG for photographs
   - Use SVG for scalable graphics
   - Use WebP for web-optimized images

## Size Guidelines

- **Icons**: 24x24, 48x48, 96x96 pixels
- **Images**: Keep under 2MB each
- **Videos**: Optimize for mobile playback (720p recommended)
- **Animations**: Keep JSON files under 500KB

## Adding New Assets

1. Add your asset files to the appropriate subfolder
2. The assets are already registered in `pubspec.yaml`
3. Run `flutter pub get` if you make changes to `pubspec.yaml`
4. Import and use in your Dart code

Remember to optimize all assets for mobile devices to maintain good app performance!

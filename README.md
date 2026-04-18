# Gauss Prep App

A progressive web app (PWA) to help students prepare for the Gauss Mathematics Competition.

## Native iPad App Option

A native SwiftUI iPad implementation is now included in [ios/GaussPrep/README.md](ios/GaussPrep/README.md).

It includes:

- Dynamic Gauss-style question generation at runtime
- Adaptive difficulty based on rolling accuracy
- Local progress tracking using UserDefaults
- iPad-ready SwiftUI practice flow

Use this folder if you want a true native app instead of the browser-based PWA.

## Features

- **Practice Mode**: Answer randomized Gauss problems with immediate feedback and explanations
- **Timed Test Mode**: 10-minute timed tests to simulate contest conditions
- **Adaptive Difficulty**: Automatically adjusts difficulty (1-10) based on performance using a simple algorithm
- **Progress Tracking**: Track correct answers, streaks, and earned points
- **Local Storage**: Progress saves automatically in the browser (offline capable)
- **iPad Optimized**: Responsive design perfect for iPad and touch devices
- **PWA Support**: Can be installed to home screen like a native app
- **PDF Import**: Import CEMC Gauss past contest papers directly from PDF
- **Help & Difficulty Guide**: Compare Gauss 7 vs Gauss 8 difficulty levels

## File Structure

```text
Gauss_prep/
├── index.html      # Main app layout
├── styles.css      # Responsive styling for iPad
├── app.js          # Core app logic and event handling
├── problems.js     # Problem database with solutions
├── manifest.json   # PWA configuration
├── ios/            # Native iPad SwiftUI source files
│   └── GaussPrep/
│       ├── GaussPrepApp.swift
│       ├── Models/
│       ├── Services/
│       ├── ViewModels/
│       ├── Views/
│       └── README.md
└── README.md       # This file
```

## How to Use

1. Open `index.html` in a modern browser (Chrome, Safari, Firefox)
2. Click **Batch Download All Gauss PDFs** to open all Gauss contest PDFs (7, 8, 9) and Pascal in new tabs for quick download.
3. Alternatively, click **Download CEMC PDFs** to browse the Gauss contest page manually.
4. Download a PDF contest paper and answer key.
5. Click **Import PDF** and choose the downloaded PDF. The app will attempt to load questions and the answer key from the file.
6. On iPad, open in Safari and tap "Share" → "Add to Home Screen" for PWA experience
7. Choose Practice Mode for unlimited practice or Timed Test for contest simulation
8. Progress is saved automatically to device storage
9. If the PDF answer key cannot be parsed, the imported questions will still load for review mode.

## Problem Database

Currently includes 5 sample problems. To add more:

1. Edit `problems.js`
2. Add new problem objects with this structure:

   ```javascript
   {
     id: 6,
     question: "Your question here?",
     options: ["Option A", "Option B", "Option C", "Option D"],
     answer: "Correct Option",
     explanation: "Explanation of why this is correct"
   }
   ```

## Future Enhancements

- [ ] Multi-user profiles for family use
- [ ] Detailed topic filtering (Number Theory, Geometry, etc.)
- [ ] Leaderboard and achievements
- [ ] Audio feedback and notifications
- [ ] Cloud sync for cross-device progress

## Technical Stack

- Vanilla JavaScript (no frameworks)
- CSS3 with responsive design
- LocalStorage API for persistence
- PWA (Service Worker ready - can be added later)

## Browser Support

- Chrome 51+
- Safari 11+
- Firefox 55+
- Edge 15+

## License

Educational use only - based on CEMC Gauss Contest materials.

## Setup Instructions

1. Clone or download this repository
2. Open `index.html` in your browser
3. No build process or dependencies required!

## Offline Usage

The app works offline once loaded. All data is stored locally on your device using browser localStorage.

## Notes for iPad Users

- Use landscape mode for better question layout
- Test on iPad 6th generation or newer for best experience
- Can be used without WiFi after first load

# Native iPad App (SwiftUI)

This folder contains a native SwiftUI implementation for adaptive, dynamically generated Gauss-style practice.

## What is implemented

- Dynamic question generation at runtime (no question bank database required)
- Topic coverage: Arithmetic, Algebra, Geometry, Number Theory, Logic
- Adaptive difficulty (1 to 10) based on rolling accuracy
- Local progress persistence with UserDefaults
- iPad-friendly SwiftUI practice screen

## Files

- GaussPrepApp.swift: App entry point
- Models/Question.swift: Topic, generated question, and session stats models
- Services/QuestionGenerator.swift: Dynamic question generation templates
- Services/AdaptiveEngine.swift: Accuracy-driven difficulty adjustments
- ViewModels/PracticeSessionViewModel.swift: Session state, scoring, storage
- Views/ContentView.swift: Main practice UI

## Run in Xcode

1. Open Xcode and create a new iOS App project named GaussPrep.
2. Choose SwiftUI and Swift.
3. Drag all files from this folder into the Xcode project navigator.
4. Replace the default template app/content files if prompted.
5. In target settings, set Device to iPad (or Universal) and run on an iPad simulator.

## If You Do Not Have a Mac

You can still build for iPad. Use one of these options:

1. Cloud Mac (recommended for this SwiftUI codebase)

- Use a hosted macOS service such as MacStadium, Codemagic, or GitHub Actions macOS runners.
- Build and archive the SwiftUI app remotely.
- Distribute to your iPad via TestFlight.

1. Keep this repository as web app on iPad now

- Your existing PWA in the repository already runs on iPad Safari.
- This is the fastest path for next-month contest prep.
- You can still keep adaptive logic and dynamic generation in JavaScript.

1. Rebuild in cross-platform framework (if you want no local Mac dependency)

- Flutter + Codemagic, or React Native + Expo EAS can build iOS in the cloud.
- This requires rewriting the current Swift files into Flutter or React Native.

Notes:

- For App Store/TestFlight distribution, you still need an Apple Developer account.
- Without any Mac access (local or cloud), you cannot compile and sign a native Swift iOS build.

## Recommended Path For Your Timeline

For a competition next month:

1. Use the existing PWA immediately for student practice.
2. In parallel, use a cloud macOS build service to package the SwiftUI app for TestFlight.
3. Move students to TestFlight once stable.

## Build In GitHub Actions (No Mac Required Locally)

This repository now includes:

- [.github/workflows/ios-cloud-build.yml](../../.github/workflows/ios-cloud-build.yml)
- [ios/GaussPrep/project.yml](project.yml)

How to use it:

1. Push this repository to GitHub.
2. Open the Actions tab and run iOS Cloud Build (or push changes under ios/GaussPrep).
3. After the workflow finishes, download the artifact named gaussprep-simulator-app.

What this workflow does:

- Uses a macOS runner with Xcode 15.4.
- Generates an Xcode project from project.yml using XcodeGen.
- Builds the app for iOS Simulator.
- Uploads the built simulator app as a zip artifact.

Important:

- This workflow verifies the native Swift code compiles in the cloud.
- TestFlight/App Store deployment requires code signing and Apple Developer credentials.

## TestFlight Upload In GitHub Actions

This repository now also includes:

- [.github/workflows/ios-testflight-release.yml](../../.github/workflows/ios-testflight-release.yml)

Use this when you are ready to upload to TestFlight.

Required GitHub repository secrets:

- IOS_KEYCHAIN_PASSWORD: Random password used for temporary CI keychain
- IOS_CERTIFICATE_P12_BASE64: Base64 of your Apple Distribution certificate (.p12)
- IOS_CERTIFICATE_PASSWORD: Password used when exporting the .p12
- IOS_PROVISIONING_PROFILE_BASE64: Base64 of App Store provisioning profile (.mobileprovision)
- IOS_TEAM_ID: Apple Developer Team ID
- IOS_BUNDLE_IDENTIFIER: Bundle ID for this app (for example, com.gaussprep.app)
- APPLE_API_KEY_ID: App Store Connect API key ID
- APPLE_API_ISSUER_ID: App Store Connect API issuer ID
- APPLE_API_PRIVATE_KEY_BASE64: Base64 of AuthKey_XXXX.p8

How to run:

1. Add the secrets above in GitHub repository settings.
2. Open Actions and run iOS TestFlight Release.
3. Wait for precheck-secrets to validate configuration.
4. Wait for Upload to TestFlight step to complete.
5. Open App Store Connect TestFlight to manage internal/external testers.

Notes:

- The workflow now fails fast in precheck-secrets and lists missing secret names.
- The workflow builds a signed Release archive, exports an IPA, and uploads it.
- Keep bundle identifier, provisioning profile, certificate, and team ID consistent.

## Adaptive behavior

- The engine keeps a rolling window of recent answers.
- If rolling accuracy is at least 80 percent, difficulty increases.
- If rolling accuracy is at most 50 percent, difficulty decreases.
- Difficulty changes are throttled with a short cooldown to avoid oscillation.

## Next recommended additions

- Add a focused Practice by Topic mode.
- Add a timed mock contest mode (25 questions, contest-like pacing).
- Add richer Gauss-style templates for combinatorics and advanced geometry.
- Add analytics by topic to detect weak areas.

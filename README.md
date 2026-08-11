# ecommerce_app

A lightweight Flutter e-commerce sample app for learning and rapid prototyping.

**What it is**

- **Simple storefront:** Browse products, view details, and open a product edit form.
- **Purpose:** Demonstrates app structure, routing, and basic state flows for an e-commerce UI.

**Quick Start**

Prerequisites: Flutter SDK installed and a connected device or emulator.

- Install dependencies:

```bash
flutter pub get
```

- Run on a connected device or emulator:

```bash
flutter run
```

- Build release APK (Android):

```bash
flutter build apk --release
```

- Build for web:

```bash
flutter build web
```

**Project Structure**

- `lib/main.dart`: App entrypoint and bootstrap. See [lib/main.dart](lib/main.dart#L1).
- `lib/routes/app_router.dart`: App navigation and route definitions. See [lib/routes/app_router.dart](lib/routes/app_router.dart#L1).
- `lib/models/product.dart`: Product data model. See [lib/models/product.dart](lib/models/product.dart#L1).
- `lib/screens/`: UI screens including home, product list, product detail, and product form (e.g., [lib/screens/product_list_screen.dart](lib/screens/product_list_screen.dart#L1)).

**Features**

- Product listing and detail views
- Add / edit product form
- Responsive for mobile & web

**Testing**

- Run unit & widget tests:

```bash
flutter test
```

**Development Tips**

- To run a specific device: `flutter devices` then `flutter run -d <deviceId>`.
- When changing native Android or iOS code, run a full rebuild (`flutter clean` then `flutter run`).

**Contributing**

- Feel free to open issues or send pull requests. Keep changes focused and include tests when appropriate.

**License & Contact**

- Add a `LICENSE` file to declare project licensing. For questions, open an issue or contact the repository owner.

---

If you'd like, I can also:

- add a short demo GIF or screenshot to this README
- add a `CONTRIBUTING.md` template and `ISSUE_TEMPLATE`
- create GitHub Actions to run `flutter test` on PRs

Tell me which of those you'd like next.

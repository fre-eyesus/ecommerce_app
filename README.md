# ecommerce_app

A lightweight Flutter e-commerce sample app designed to demonstrate navigation, screen composition, and simple in-memory product management. The current implementation focuses on clear app structure and predictable data flow rather than a full enterprise state-management stack.

## Overview

This app allows a user to:

- view a product list
- open a product detail page
- add a new product
- edit an existing product
- delete a product from the catalog

The project is intentionally small and easy to follow, making it useful for learning Flutter app organization and route-driven UI flow.

## Architecture overview

The app follows a simple layered structure with a clear separation between:

- App bootstrap and configuration
- Navigation and routing
- Screen-level state and UI logic
- Data model definitions

### 1. App bootstrap

The entry point is [lib/main.dart](lib/main.dart). It creates the `EcommerceApp` widget and configures the app shell using `MaterialApp`.

Key responsibilities:

- sets the app title
- applies the base theme
- defines the initial route
- registers the generated route factory via `AppRouter.generateRoute`

### 2. Routing layer

The routing layer is defined in [lib/routes/app_router.dart](lib/routes/app_router.dart).

`AppRouter` centralizes all route names and screen creation logic:

- `/` → `HomeScreen`
- `/product-form` → `ProductFormScreen`
- `/product-detail` → `ProductDetailScreen`

This ensures screens are created in one place and navigation remains easy to extend as the app grows.

### 3. Screen layer

Screens live under [lib/screens](lib/screens):

- [lib/screens/home_screen.dart](lib/screens/home_screen.dart): main inventory/dashboard screen, owns the in-memory product list
- [lib/screens/product_list_screen.dart](lib/screens/product_list_screen.dart): catalog-style list screen used as a supplemental example
- [lib/screens/product_detail_screen.dart](lib/screens/product_detail_screen.dart): displays the selected product and allows editing
- [lib/screens/product_form_screen.dart](lib/screens/product_form_screen.dart): form screen for create/update operations

The UI currently relies on `StatefulWidget` state for local screen behavior and uses `Navigator` for screen transitions.

### 4. Domain/data model layer

The app contains a product model in [lib/models/product.dart](lib/models/product.dart), which defines the main data-shape used by the screens:

- `id`
- `title`
- `description`
- `price`
- `imageUrl`

There is also a more structured product domain/data setup under [lib/features/product](lib/features/product), including:

- [lib/features/product/domain/entities/product.dart](lib/features/product/domain/entities/product.dart): entity-based product definition using `Equatable`
- [lib/features/product/data/models/product_model.dart](lib/features/product/data/models/product_model.dart): JSON serialization helpers for converting product data to and from maps

This indicates the project is evolving toward a cleaner layered design, while the active UI still uses the simpler model in [lib/models/product.dart](lib/models/product.dart).

## Data flow

The current app uses a straightforward, route-driven data flow without a separate state manager or repository layer.

### 1. App start

On launch, [lib/main.dart](lib/main.dart) initializes the app and opens the home route.

### 2. Home screen owns the product list

[lib/screens/home_screen.dart](lib/screens/home_screen.dart) maintains the primary `_products` list in local state. This list acts as the app’s source of truth while the user is interacting with the UI.

### 3. Add product flow

When the user taps the add button:

1. The app calls `Navigator.pushNamed(context, AppRouter.productForm)`.
2. [lib/screens/product_form_screen.dart](lib/screens/product_form_screen.dart) validates form input.
3. On save, it creates a new `Product` instance and returns it via `Navigator.pop(context, resultProduct)`.
4. The home screen receives the returned result, adds the product to `_products`, and updates the UI.

### 4. View/edit product flow

When a product is selected from the home list:

1. The app pushes the detail route with the selected product as an argument.
2. [lib/screens/product_detail_screen.dart](lib/screens/product_detail_screen.dart) stores the initial product in local state.
3. If the user edits the product, the detail screen calls the form route with the current product.
4. The edited product is returned with `Navigator.pop` and the screen updates its local state.
5. The detail screen uses `PopScope` to ensure the updated product is also returned when the user navigates back using the system back action.

### 5. Delete product flow

The delete flow in [lib/screens/home_screen.dart](lib/screens/home_screen.dart):

1. opens a confirmation dialog
2. removes the product from `_products`
3. shows a snackbar confirmation

This keeps deletion logic simple and local to the state owner.

## State management pattern

The current app uses a lightweight state pattern:

- local `StatefulWidget` state for screen-specific behavior
- route arguments for passing one-off product objects between screens
- `Navigator.pop` for returning updated results to the previous screen
- simple UI feedback using `ScaffoldMessenger` and snackbars

This is ideal for a small learning app, but it would need a more formal state-management layer if the app grows to include persistence, API calls, business logic, or multiple independent screens sharing data.

## Data persistence status

At present, the app is using in-memory sample data and does not store products in a database or remote service.

The JSON conversion utilities in [lib/features/product/data/models/product_model.dart](lib/features/product/data/models/product_model.dart) provide a starting point for future persistence or API integration, and the app is structured in a way that can evolve toward a repository and use-case pattern.

## Project structure

```text
lib/
├── main.dart
├── models/
│   └── product.dart
├── routes/
│   └── app_router.dart
├── screens/
│   ├── home_screen.dart
│   ├── product_detail_screen.dart
│   ├── product_form_screen.dart
│   └── product_list_screen.dart
├── features/
│   └── product/
│       ├── data/
│       │   └── models/
│       │       └── product_model.dart
│       └── domain/
│           └── entities/
│               └── product.dart
└── ...
```

## Getting started

Prerequisites: Flutter SDK installed and a connected device or emulator.

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

Build for Android release:

```bash
flutter build apk --release
```

Build for web:

```bash
flutter build web
```

## Notes for contributors

- Keep screen logic simple and easy to follow.
- Prefer route-based navigation when passing product data between screens.
- If the app is extended, consider introducing a repository layer or a dedicated state-management solution before the data model becomes more complex.
- Preserve the current clear app structure so the project remains friendly for learning and experimentation.

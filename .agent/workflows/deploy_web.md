---
description: Deploy Flutter Web App to Vercel
---

# Deploy Flutter Web to Vercel

Follow these steps to properly build and deploy your Flutter web app to Vercel.

> [!IMPORTANT]
> Vercel does NOT have Flutter installed. You must **build locally** and deploy the pre-built `build/web` directory.

## Steps

1. **Clean previous builds**
```powershell
flutter clean
```

// turbo
2. **Get dependencies**
```powershell
flutter pub get
```

// turbo
3. **Build for web with correct base href**
```powershell
flutter build web --release --base-href="/"
```

4. **Deploy to Vercel**
   - Open your Vercel dashboard
   - Select your project
   - Deploy the `build/web` directory
   - OR use Vercel CLI:
   ```powershell
   cd build/web
   vercel --prod
   ```

## Troubleshooting

If images still don't appear after deployment:

1. **Check browser console** for 404 errors on asset paths
2. **Verify assets are in build output**:
   ```powershell
   ls build/web/flutter_assets/assets/images/
   ```
3. **Clear Vercel cache**: In Vercel dashboard, go to Settings → Clear Build Cache
4. **Redeploy**: Force a new deployment after clearing cache

## Notes

- Always use `--base-href="/"` for root domain deployments on Vercel
- The `build/web` directory contains all files needed for deployment
- Assets are bundled in `build/web/flutter_assets/`

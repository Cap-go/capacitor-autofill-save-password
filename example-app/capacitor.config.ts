import type { CapacitorConfig } from '@capacitor/cli';

import pkg from './package.json';

const config: CapacitorConfig = {
  appId: 'app.capgo.autofill.save.password.example',
  appName: '@capgo/capacitor-autofill-save-password',
  webDir: 'dist',
  plugins: {
    SplashScreen: {
      launchAutoHide: false,
    },
    CapacitorUpdater: {
      appId: 'app.capgo.autofill.save.password.example',
      autoUpdate: true,
      autoSplashscreen: true,
      directUpdate: 'always',
      version: pkg.version,
    },
  },
};

export default config;

import { CapacitorUpdater } from '@capgo/capacitor-updater';
import { Capacitor } from '@capacitor/core';
import { SavePassword } from '@capgo/capacitor-autofill-save-password';

window.testPromptDialog = () => {
    const username = document.getElementById("usernameInput").value;
    const password = document.getElementById("passwordInput").value;
    SavePassword.promptDialog({ username, password, url: "console.capgo.app" })
}

window.readPassword = async () => {
    const password = await SavePassword.readPassword()
    alert(JSON.stringify(password))
}

if (Capacitor.isNativePlatform()) {
  CapacitorUpdater.notifyAppReady().catch((error) => {
    console.error('Capgo notifyAppReady failed', error);
  });
}

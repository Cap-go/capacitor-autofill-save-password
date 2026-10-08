import { CapacitorUpdater } from '@capgo/capacitor-updater';
import { Capacitor } from '@capacitor/core';
import { SavePassword } from '@capgo/capacitor-autofill-save-password';

const output = document.getElementById('plugin-output');
const platformChip = document.getElementById('platform-chip');
const nativeChip = document.getElementById('native-chip');
const usernameInput = document.getElementById('usernameInput');
const passwordInput = document.getElementById('passwordInput');
const urlInput = document.getElementById('urlInput');
const titleInput = document.getElementById('titleInput');

const setOutput = (value) => {
  const text = typeof value === 'string' ? value : JSON.stringify(value, null, 2);
  output.textContent = text;
};

const appendLog = (label, value) => {
  const stamp = new Date().toISOString();
  const body = typeof value === 'string' ? value : JSON.stringify(value, null, 2);
  const previous = output.textContent === 'Tap a button to run a plugin method.' ? '' : `${output.textContent}\n\n`;
  output.textContent = `${previous}[${stamp}] ${label}\n${body}`;
};

const readFormOptions = () => {
  const username = usernameInput.value.trim();
  const password = passwordInput.value;
  const url = urlInput.value.trim();
  const title = titleInput.value.trim();

  const options = { username, password };
  if (url) {
    options.url = url;
  }
  if (title) {
    options.title = title;
  }
  return options;
};

const platform = Capacitor.getPlatform();
const isNative = Capacitor.isNativePlatform();

platformChip.textContent = `Platform: ${platform}`;
nativeChip.textContent = isNative ? 'Native: yes' : 'Native: no';
nativeChip.dataset.native = String(isNative);

document.getElementById('btn-prompt').addEventListener('click', async () => {
  const options = readFormOptions();
  try {
    await SavePassword.promptDialog(options);
    appendLog('promptDialog resolved', { options, note: 'Check the system UI for the user choice.' });
  } catch (error) {
    appendLog('promptDialog error', error?.message ?? String(error));
  }
});

document.getElementById('btn-read').addEventListener('click', async () => {
  try {
    const result = await SavePassword.readPassword();
    appendLog('readPassword', result);
  } catch (error) {
    appendLog('readPassword error', error?.message ?? String(error));
  }
});

document.getElementById('btn-version').addEventListener('click', async () => {
  try {
    const result = await SavePassword.getPluginVersion();
    appendLog('getPluginVersion', result);
  } catch (error) {
    appendLog('getPluginVersion error', error?.message ?? String(error));
  }
});

setOutput('Ready. Platform: ' + platform + (isNative ? ' (native)' : ' (web preview)'));

if (isNative) {
  CapacitorUpdater.notifyAppReady().catch((error) => {
    console.error('Capgo notifyAppReady failed', error);
    appendLog('notifyAppReady error', error?.message ?? String(error));
  });
}

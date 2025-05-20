import { SavePassword } from '@capgo/capacitor-autofill-save-password';

window.testPromptDialog = () => {
    const username = document.getElementById("usernameInput").value;
    const password = document.getElementById("passwordInput").value;
    SavePassword.promptDialog({ username, password })
}

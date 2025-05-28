import { SavePassword } from '@capgo/capacitor-autofill-save-password';

window.testPromptDialog = () => {
    const username = document.getElementById("usernameInput").value;
    const password = document.getElementById("passwordInput").value;
    SavePassword.promptDialog({ username, password, url: "web.capgo.app" })
}

window.readPassword = async () => {
    const password = await SavePassword.readPassword()
    alert(JSON.stringify(password))
}

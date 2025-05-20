import { SavePassword } from '@capgo/capacitor-autofill-save-password';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    SavePassword.echo({ value: inputValue })
}

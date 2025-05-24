import { SavePassword } from '@capgo/capacitor-autofill-save-password';
import './style.css';

// Add TypeScript declaration for the global function
declare global {
    interface Window {
        testPromptDialog: () => void;
    }
}

window.testPromptDialog = () => {
    const username = (document.getElementById("usernameInput") as HTMLInputElement).value;
    const password = (document.getElementById("passwordInput") as HTMLInputElement).value;
    SavePassword.promptDialog({ username, password });
};

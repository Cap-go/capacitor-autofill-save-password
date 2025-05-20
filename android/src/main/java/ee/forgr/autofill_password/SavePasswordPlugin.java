package ee.forgr.autofill_password;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "SavePassword")
public class SavePasswordPlugin extends Plugin {

    @PluginMethod
    public void promptDialog(PluginCall call) {
        String username = call.getString("username", "");
        String password = call.getString("password", "");

        // TODO: Implement the logic to display the dialog and save the password
        // For now, we'll just resolve the promise
        call.resolve();
    }
}

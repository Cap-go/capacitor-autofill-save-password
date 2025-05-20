package ee.forgr.autofill_password;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import android.util.Log;
import android.os.CancellationSignal;
import androidx.credentials.CredentialManager;
import androidx.credentials.CredentialManagerCallback;
import androidx.credentials.CreatePasswordRequest;
import androidx.credentials.CreateCredentialResponse;
import androidx.credentials.exceptions.CreateCredentialException;
import java.util.concurrent.Executor;

@CapacitorPlugin(name = "SavePassword")
public class SavePasswordPlugin extends Plugin {

    private static final String TAG = "SavePasswordPlugin";

    @PluginMethod
    public void promptDialog(PluginCall call) {
        String username = call.getString("username");
        String password = call.getString("password");

        if (username == null || username.isEmpty()) {
            call.reject("Username cannot be empty.");
            Log.w(TAG, "Username was null or empty.");
            return;
        }

        if (password == null) {
            call.reject("Password cannot be null. Provide an empty string if the password is meant to be empty.");
            Log.w(TAG, "Password was null.");
            return;
        }

        if (getActivity() == null) {
            call.reject("Activity is not available to show dialog.");
            Log.e(TAG, "Activity was null, cannot access CredentialManager.");
            return;
        }

        // Build the CreatePasswordRequest
        CreatePasswordRequest createPasswordRequest = new CreatePasswordRequest(username, password);

        // Get the CredentialManager instance
        CredentialManager credentialManager = CredentialManager.create(getActivity());

        // Set up executor and cancellation signal
        Executor executor = getActivity().getMainExecutor();
        CancellationSignal cancellationSignal = new CancellationSignal();

        credentialManager.createCredentialAsync(
            getActivity(),
            createPasswordRequest,
            cancellationSignal,
            executor,
            new CredentialManagerCallback<CreateCredentialResponse, CreateCredentialException>() {
                @Override
                public void onResult(CreateCredentialResponse result) {
                    JSObject response = new JSObject();
                    response.put("prompted", true);
                    Log.d(TAG, "Password save prompt completed successfully.");
                    call.resolve(response);
                }

                @Override
                public void onError(CreateCredentialException e) {
                    String errorMessage = "Failed to save password credential: " + e.getMessage();
                    Log.e(TAG, errorMessage, e);
                    call.reject(errorMessage, e);
                }
            }
        );
    }
}

package ee.forgr.autofill_password;

import android.app.Activity;
import android.os.Build;
import android.util.Log;

import androidx.credentials.CredentialManager;
import androidx.credentials.CreatePasswordRequest;
import androidx.credentials.CreateCredentialResponse;
import androidx.credentials.PendingGetCredentialRequest;
import androidx.credentials.CredentialManagerCallback;
import androidx.credentials.exceptions.CreateCredentialException;

import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.util.HashMap;
import java.util.Map;

import androidx.core.content.ContextCompat;

@CapacitorPlugin(name = "SavePassword")
public class SavePasswordPlugin extends Plugin {
    private static final String TAG = "CredentialManager";
    private CredentialManager credentialManager;
    private Map<String, PendingGetCredentialRequest> pendingRequestsByElementId = new HashMap<>();

    @Override
    public void load() {
        super.load();
        try {
            credentialManager = CredentialManager.create(getContext());
        } catch (Exception e) {
            Log.e(TAG, "Error initializing CredentialManager", e);
        }
    }

    @PluginMethod
    public void promptDialog(final PluginCall call) {
        if (!isCredentialManagerAvailable(call)) {
            return;
        }

        String username = call.getString("username");
        String password = call.getString("password");

        if (username == null || username.isEmpty()) {
            call.reject("Username is required");
            return;
        }

        if (password == null || password.isEmpty()) {
            call.reject("Password is required");
            return;
        }

        try {
            // Build request directly with username & password (API 1.5.0 signature)
            CreatePasswordRequest request = new CreatePasswordRequest(username, password);
            
            // Execute on main thread
            bridge.executeOnMainThread(() -> {
                Activity activity = getActivity();
                if (activity == null) {
                    call.reject("Activity not available");
                    return;
                }

                try {
                    credentialManager.createCredentialAsync(
                        activity,
                        request,
                        null,
                        ContextCompat.getMainExecutor(getContext()),
                        new CredentialManagerCallback<CreateCredentialResponse, CreateCredentialException>() {
                            @Override
                            public void onResult(CreateCredentialResponse response) {
                                call.resolve();
                            }

                            @Override
                            public void onError(CreateCredentialException e) {
                                call.reject("Error saving credential: " + e.getMessage(), e);
                            }
                        }
                    );
                } catch (Exception e) {
                    call.reject("Error saving credential", e);
                }
            });
        } catch (Exception e) {
            call.reject("Error building save credential request", e);
        }
    }

    private boolean isCredentialManagerAvailable(PluginCall call) {
        if (credentialManager == null) {
            call.reject("Credential Manager not available on this device");
            return false;
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            call.reject("Credential Manager requires Android API level 28 or higher");
            return false;
        }

        return true;
    }
}

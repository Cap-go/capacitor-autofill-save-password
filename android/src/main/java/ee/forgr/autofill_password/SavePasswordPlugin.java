package ee.forgr.autofill_password;

import android.app.Activity;
import android.os.Build;
import android.util.Log;
import androidx.core.content.ContextCompat;
import androidx.credentials.CreateCredentialResponse;
import androidx.credentials.CreatePasswordRequest;
import androidx.credentials.CredentialManager;
import androidx.credentials.CredentialManagerCallback;
import androidx.credentials.GetCredentialRequest;
import androidx.credentials.GetCredentialResponse;
import androidx.credentials.GetPasswordOption;
import androidx.credentials.PasswordCredential;
import androidx.credentials.PendingGetCredentialRequest;
import androidx.credentials.exceptions.CreateCredentialException;
import androidx.credentials.exceptions.GetCredentialException;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CapacitorPlugin(name = "SavePassword")
public class SavePasswordPlugin extends Plugin {

    private final String pluginVersion = "8.0.8";
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

    @PluginMethod
    public void readPassword(final PluginCall call) {
        if (!isCredentialManagerAvailable(call)) {
            return;
        }

        try {
            GetCredentialRequest request = new GetCredentialRequest(List.of(new GetPasswordOption()));

            bridge.executeOnMainThread(() -> {
                Activity activity = getActivity();
                if (activity == null) {
                    call.reject("Activity not available");
                    return;
                }

                try {
                    credentialManager.getCredentialAsync(
                        activity,
                        request,
                        null,
                        ContextCompat.getMainExecutor(getContext()),
                        new CredentialManagerCallback<GetCredentialResponse, GetCredentialException>() {
                            @Override
                            public void onResult(GetCredentialResponse response) {
                                if (response.getCredential() instanceof PasswordCredential) {
                                    PasswordCredential credential = (PasswordCredential) response.getCredential();
                                    JSObject result = new JSObject();
                                    result.put("username", credential.getId());
                                    result.put("password", credential.getPassword());
                                    call.resolve(result);
                                } else {
                                    call.reject("No password credential found");
                                }
                            }

                            @Override
                            public void onError(GetCredentialException e) {
                                call.reject("Error retrieving credential: " + e.getMessage(), e);
                            }
                        }
                    );
                } catch (Exception e) {
                    call.reject("Error retrieving credential", e);
                }
            });
        } catch (Exception e) {
            call.reject("Error building get credential request", e);
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

    @PluginMethod
    public void getPluginVersion(final PluginCall call) {
        try {
            final JSObject ret = new JSObject();
            ret.put("version", this.pluginVersion);
            call.resolve(ret);
        } catch (final Exception e) {
            call.reject("Could not get plugin version", e);
        }
    }
}

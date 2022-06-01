package ru.kodazm.permissions;

import android.Manifest;
import android.app.Activity;
import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import ru.kodazm.permissions.pigeons.Permissions;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import io.flutter.plugin.common.PluginRegistry;

public class PermissionsChecker implements Permissions.PermissionsChecker, PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {
    private static final int PERMISSIONS_REQUEST_STORAGE = 111;
    private static final int PERMISSIONS_USAGE = 112;
    private static final int PERMISSIONS_DRAW_APPICATION = 113;
    private static final int PERMISSIONS_NOTIFICATION_LISTENER = 114;
    private static final int PERMISSIONS_WRITE_SETTINGS = 115;
    private static final int UNINSTALL_REQUEST_CODE = 116;
    private static final int UNINSTALL_REQUEST_CODE_ACTIVITY = 117;
    private static final int PERMISSIONS_REQUEST_CLEAN_CACHE = 118;

    private List<Callable<Void>> callables = new ArrayList<>();

    @Nullable
    private Activity activity;

    public  PermissionsChecker() {

    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    private void callListener() {
        for (Callable callable : callables) {
            try {
                callable.call();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void checkPermissionUsageSetting(Permissions.Result<Permissions.PermissionsResponse> result) {
        this.callables.clear();

        if (isPermissionUsageSettingAllowed(this.activity)) {
            Permissions.PermissionsResponse response = new Permissions.PermissionsResponse();
            response.setResult(true);
            result.success(response);
            return;
        }

        this.callables.add(() -> {
            Permissions.PermissionsResponse response = new Permissions.PermissionsResponse();
            response.setResult(isPermissionUsageSettingAllowed(this.activity));
            result.success(response);

            return null;
        });

        if ((Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)) {
            assert this.activity != null;
            this.activity.startActivityForResult(new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS), PERMISSIONS_USAGE);
        }
    }

    public final boolean isPermissionUsageSettingAllowed(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            boolean granted = false;
            try {
                AppOpsManager ops = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
                int mode = ops.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.getPackageName());
                if (mode == AppOpsManager.MODE_DEFAULT) {
                    String permission = "android.permission.PACKAGE_USAGE_STATS";
                    granted = (context.checkCallingOrSelfPermission(permission) == PackageManager.PERMISSION_GRANTED);
                } else {
                    granted = (mode == AppOpsManager.MODE_ALLOWED);
                }
            } catch (Throwable e) {
            }

            return granted;
        }

        return true;
    }

    @Override
    public void checkPermissionStorage(Permissions.Result<Permissions.PermissionsResponse> result) {
        this.callables.clear();

        if (isPermissionStorageAllowed(this.activity)) {
            Permissions.PermissionsResponse response = new Permissions.PermissionsResponse();
            response.setResult(true);
            result.success(response);
            return;
        }

        this.callables.add(() -> {
            Permissions.PermissionsResponse response = new Permissions.PermissionsResponse();
            response.setResult(isPermissionStorageAllowed(this.activity)); // @todo: check permission
            result.success(response);

            return null;
        });

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            assert this.activity != null;
            ActivityCompat.requestPermissions(
                    this.activity, //activity,
                    new String[]{
                            Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    },
                    PERMISSIONS_REQUEST_STORAGE);
        }
    }


    public final boolean isPermissionStorageAllowed(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                    && ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED);
        }

        return true;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case PERMISSIONS_USAGE:
                callListener();
                break;
        }

        return false;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case PERMISSIONS_REQUEST_STORAGE:
            case PERMISSIONS_REQUEST_CLEAN_CACHE:
                callListener();
                break;
        }

        return false;
    }
}

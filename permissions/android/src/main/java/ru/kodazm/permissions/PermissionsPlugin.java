package ru.kodazm.permissions;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import ru.kodazm.permissions.pigeons.Permissions;

/**
 * PermissionsPlugin
 */
public class PermissionsPlugin implements FlutterPlugin, ActivityAware {
    PermissionsChecker checker;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        checker = new PermissionsChecker();
        Permissions.PermissionsChecker.setup(
                flutterPluginBinding.getBinaryMessenger(),
                checker
        );
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        checker.setActivity(binding.getActivity());

        binding.addRequestPermissionsResultListener(checker);
        binding.addActivityResultListener(checker);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }
}

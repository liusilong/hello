package com.lsl.hello;

import android.text.TextUtils;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * HelloPlugin
 */
public class HelloPlugin implements MethodCallHandler {
    private static int counter = 0;
    private final PluginRegistry.Registrar registrar;

    private HelloPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "hello.lsl");
        channel.setMethodCallHandler(new HelloPlugin(registrar));
        TimerTask task = new TimerTask() {
            @Override
            public void run() {
                // Native 调用 Flutter 的方法
                channel.invokeMethod("callback", "this callback from android works: " + counter++);
            }
        };
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(task, 5000, 5000);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getName")) {
            result.success("My name is LIUSILONG...");
            String message = call.argument("message");
            if (!TextUtils.isEmpty(message)) {
                Toast.makeText(registrar.context(), message, Toast.LENGTH_LONG).show();
            }
        } else if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            result.notImplemented();
        }
    }
}

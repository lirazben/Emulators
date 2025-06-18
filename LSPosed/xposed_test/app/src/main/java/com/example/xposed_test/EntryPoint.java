package com.example.xposed_test;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

import android.os.Looper;

public class EntryPoint implements IXposedHookLoadPackage {

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
        if (!lpparam.packageName.equals("android")) {
            return;
        }

        Thread t1 = new Thread(() -> {
            Looper looper;
            while (true) {
                looper = Looper.getMainLooper();
                if (looper != null) {
                    XposedBridge.log("Got main looper: " + looper);
                    break;
                }
            }

            while (true) {
                boolean inLoop = XposedHelpers.getBooleanField(looper, "mInLoop");

                if (inLoop) {
                    XposedBridge.log("In loop!!!!");
                    break;
                }
            }
        });
        t1.setDaemon(true);
        t1.start();

        XposedHelpers.findAndHookMethod("com.android.server.SystemServer",
                lpparam.classLoader, "startOtherServices",
                "com.android.server.utils.TimingsTraceAndSlog", new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) {
                        XposedBridge.log("After startOtherServices");
                    }
                });

    }
}

package cc.eevee.hellodjinni;

import android.app.Application;

public class MyApplication extends Application {

    static {
        try {
            System.loadLibrary("hellodjinni_jni");
        } catch (UnsatisfiedLinkError e) {
            System.err.println("Native code library failed to load.\n" + e);
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }
}

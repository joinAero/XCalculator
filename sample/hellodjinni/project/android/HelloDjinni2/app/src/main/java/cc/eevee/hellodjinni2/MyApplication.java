package cc.eevee.hellodjinni2;

import android.app.Application;

public class MyApplication extends Application {

    static {
        try {
            System.loadLibrary("gnustl_shared");
            System.loadLibrary("hellodjinni");
        } catch (UnsatisfiedLinkError e) {
            System.err.println("Native code library failed to load.\n" + e);
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }
}

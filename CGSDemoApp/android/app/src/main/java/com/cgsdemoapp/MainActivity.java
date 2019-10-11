package com.cgsdemoapp;

import com.facebook.react.ReactActivity;

public class MainActivity extends ReactActivity {

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "CGSDemoApp";
    }
    // public void onUnityLoad(View v) {
    //     Intent intent = new Intent(this, MainUnityActivity.class);
    //     startActivity(intent);
    // }

    // public void onUnityUnload(View v) {
    //     if(MainUnityActivity.instance != null)
    //         MainUnityActivity.instance.finish();
    //     else showToast("Show Unity First");
    // }
}

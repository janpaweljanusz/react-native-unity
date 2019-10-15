package com.cgsdemoapp;

import android.app.Activity;
import android.widget.Toast;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactMethod;

import android.content.Intent;
import android.util.Log;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import java.util.Map;
import java.util.HashMap;

public class ToastModule extends ReactContextBaseJavaModule {

  private static final String DURATION_SHORT_KEY = "SHORT";
  private static final String DURATION_LONG_KEY = "LONG";

  @Override
  public Map<String, Object> getConstants() {
    final Map<String, Object> constants = new HashMap<>();
    constants.put(DURATION_SHORT_KEY, Toast.LENGTH_SHORT);
    constants.put(DURATION_LONG_KEY, Toast.LENGTH_LONG);
    return constants;
  }

  private static final int UNITY_REQUEST = 10;
  private static final String E_ACTIVITY_DOES_NOT_EXIST = "E_ACTIVITY_DOES_NOT_EXIST";
  private static final String E_UNITY_CANCELLED = "E_UNITY_CANCELLED"; // do to Vuforia not supporting or display error - for later work.
  private static final String E_FAILED_TO_SHOW_UNITY = "E_FAILED_TO_SHOW_UNITY";
  private static final String E_NO_DATA_FOUND = "E_NO_DATA_FOUND";

  private Promise mUnityPromise;

  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intentData) {
      if (requestCode == UNITY_REQUEST) {
        if (mUnityPromise != null) {
          if (resultCode == Activity.RESULT_CANCELED) {
            mUnityPromise.reject(E_UNITY_CANCELLED, "Unity was cancelled, device dont support AR - edge cases");
          } else if (resultCode == Activity.RESULT_OK) {
            String message = intentData.getStringExtra("result"); // can be json
            if (message == null) {
              mUnityPromise.reject(E_NO_DATA_FOUND, "No data from unity - unity shut down suddenly");
            } else {
              mUnityPromise.resolve(message);
            }
          }

          mUnityPromise = null;
        }
      }
    }
  };


  ToastModule(ReactApplicationContext reactContext) {
    super(reactContext);
    reactContext.addActivityEventListener(mActivityEventListener);
  }

    @Override
  public String getName() {
    return "ToastExample";
  }
  
  public void GiveLog(){
    Log.v("kaskadowosc" ,"NONO"+ getReactApplicationContext().getCurrentActivity().getIntent() +">>"+ getReactApplicationContext().getCurrentActivity().getIntent());
  }

  // obsolete
    @ReactMethod
  public void show(String message, int duration) {
    Toast.makeText(getReactApplicationContext(), message, duration).show();
    Intent intent = new Intent(getReactApplicationContext(), MainUnityActivity.class);
    intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
    getReactApplicationContext().startActivity(intent);
  }

  @ReactMethod
  public void showUnity(String message, int duration, final Promise promise) {
    Activity currentActivity = getCurrentActivity();
    Toast.makeText(getReactApplicationContext(), message, duration).show();
    if (currentActivity == null) {
      promise.reject(E_ACTIVITY_DOES_NOT_EXIST, "Activity doesn't exist");
      return;
    }
    mUnityPromise = promise;

    try {
      Intent intent = new Intent(currentActivity, MainUnityActivity.class);

      currentActivity.startActivityForResult(intent, UNITY_REQUEST);
    } catch (Exception e) {
      mUnityPromise.reject(E_FAILED_TO_SHOW_UNITY, e);
      mUnityPromise = null;
    }
  }

}
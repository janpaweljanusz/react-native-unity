package com.cgsdemoapp;

import android.widget.Toast;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
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
  boolean isUnityLoaded = false;

  private static final int IMAGE_PICKER_REQUEST = 467081;
  private static final String E_ACTIVITY_DOES_NOT_EXIST = "E_ACTIVITY_DOES_NOT_EXIST";
  private static final String E_PICKER_CANCELLED = "E_PICKER_CANCELLED";
  private static final String E_FAILED_TO_SHOW_PICKER = "E_FAILED_TO_SHOW_PICKER";
  private static final String E_NO_IMAGE_DATA_FOUND = "E_NO_IMAGE_DATA_FOUND";

  private Promise mPickerPromise;

  private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
      if (requestCode == IMAGE_PICKER_REQUEST) {
        if (mPickerPromise != null) {
          if (resultCode == Activity.RESULT_CANCELED) {
            mPickerPromise.reject(E_PICKER_CANCELLED, "Image picker was cancelled");
          } else if (resultCode == Activity.RESULT_OK) {
            Uri uri = intent.getData();

            if (uri == null) {
              mPickerPromise.reject(E_NO_IMAGE_DATA_FOUND, "No image data found");
            } else {
              mPickerPromise.resolve(uri.toString());
            }
          }

          mPickerPromise = null;
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
  
  @Override
  public Map<String, Object> getConstants() {
    final Map<String, Object> constants = new HashMap<>();
    constants.put(DURATION_SHORT_KEY, Toast.LENGTH_SHORT);
    constants.put(DURATION_LONG_KEY, Toast.LENGTH_LONG);
    return constants;
  }
  
  public void GiveLog(){
    Log.v("kaskadowosc" ,"NONO"+ getReactApplicationContext().getCurrentActivity().getIntent() +">>"+ getReactApplicationContext().getCurrentActivity().getIntent());
  }

    @ReactMethod
  public void show(String message, int duration) {
    Log.v("kaskadowosc" ,"kaskadowosc"+ getReactApplicationContext().getCurrentActivity().getIntent() +">>"+ getReactApplicationContext().getCurrentActivity().getIntent());
    Toast.makeText(getReactApplicationContext(), message, duration).show();
    Intent intent = new Intent(getReactApplicationContext(), MainUnityActivity.class);
    if (isUnityLoaded){
      // intent.putExtra("doQuit", true);
    }
    intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
    getReactApplicationContext().startActivity(intent);
    // callUnity();
    isUnityLoaded = !isUnityLoaded;
  }

  @ReactMethod
  public void showUnity(final Promise promise) {
    Activity currentActivity = getCurrentActivity();

    if (currentActivity == null) {
      promise.reject(E_ACTIVITY_DOES_NOT_EXIST, "Activity doesn't exist");
      return;
    }

    // Store the promise to resolve/reject when picker returns data
    mPickerPromise = promise;

    try {
      Intent intent = new Intent(currentActivity, MainUnityActivity.class);

      currentActivity.startActivityForResult(intent, IMAGE_PICKER_REQUEST);
    } catch (Exception e) {
      mPickerPromise.reject(E_FAILED_TO_SHOW_PICKER, e);
      mPickerPromise = null;
    }
  }


  // public void callUnity(View v){
  //   Intent intent = new Intent(this, MainUnityActivity.class);
  //   startActivity(intent);
  // }
}
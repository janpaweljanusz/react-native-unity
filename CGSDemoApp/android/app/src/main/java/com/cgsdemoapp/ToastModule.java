package com.cgsdemoapp;

import android.widget.Toast;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import java.util.Map;
import java.util.HashMap;

public class ToastModule extends ReactContextBaseJavaModule {

  private static final String DURATION_SHORT_KEY = "SHORT";
  private static final String DURATION_LONG_KEY = "LONG";

  ToastModule(ReactApplicationContext reactContext) {
    super(reactContext);
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

    @ReactMethod
  public void show(String message, int duration) {
    Toast.makeText(getReactApplicationContext(), message, duration).show();
    Intent intent = new Intent(getReactApplicationContext(), MainUnityActivity.class);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    getReactApplicationContext().startActivity(intent);
    // callUnity();
  }
  // public void callUnity(View v){
  //   Intent intent = new Intent(this, MainUnityActivity.class);
  //   startActivity(intent);
  // }
}
using c8;
using Capnp;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Threading;
using UnityEngine;

namespace XRInternal {

public class XRAndroidWrapper {

#if (UNITY_ANDROID && !UNITY_EDITOR)

  // We need these so that we can call DllImport.
  [DllImport ("XRPlugin")]
  private static extern void c8_loadXRDll();

  AndroidJavaObject androidXR;

  public static XRAndroidWrapper create(int renderingSystem) {
    return new XRAndroidWrapper(renderingSystem);
  }

  public XRAndroidWrapper(int renderingSystem) {
    // Load the native library required by XRAndroid's JNI layer.
    c8_loadXRDll();

    // Get the UnityPlayer Activity.
    AndroidJavaObject currentActivity = getUnityPlayerAcitivty();

    // Create the XRAndroid.
    AndroidJavaClass xrAndroidClass = getXRAndroidClass();
    xrAndroidClass.CallStatic("create", currentActivity, renderingSystem);

    androidXR = xrAndroidClass.CallStatic<AndroidJavaObject>("getInstance");
  }

  private static AndroidJavaObject getUnityPlayerAcitivty() {
    AndroidJavaClass unityPlayer =
      new AndroidJavaClass("com.unity3d.player.UnityPlayer");
    AndroidJavaObject currentActivity =
      unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
    return currentActivity;
  }

  private static AndroidJavaClass getXRAndroidClass() {
    return new AndroidJavaClass("com.the8thwall.reality.app.xr.android.XREngine");
  }

  public void destroy() {
    AndroidJavaClass xrAndroidClass = getXRAndroidClass();
    xrAndroidClass.CallStatic("destroy");
  }

  public void configureXR(MessageBuilder config) {
  #if UNITY_2019_1_OR_NEWER
    sbyte[] b = Serialize.writeSBytes(config);
  #else
    byte[] b = Serialize.writeBytes(config);
  #endif

    // Configure the reality engine.
    androidXR.Call("configure", b);
  }

  public void setManagedCameraRGBATexture(
    System.IntPtr texHandle, int width, int height, int renderingSystem) {
    androidXR.Call(
      "setUnityManagedCameraRGBATexture", (long) texHandle, width, height, renderingSystem);
  }

  public void setManagedCameraYTexture(
    System.IntPtr texHandle, int width, int height, int renderingSystem) {
    androidXR.Call(
      "setUnityManagedCameraYTexture", (long) texHandle, width, height, renderingSystem);
  }

  public void setManagedCameraUVTexture(
    System.IntPtr texHandle, int width, int height, int renderingSystem) {
    androidXR.Call(
      "setUnityManagedCameraUVTexture", (long) texHandle, width, height, renderingSystem);
  }

  public void resume() { androidXR.Call("resume"); }

  public void recenter() { androidXR.Call("recenter"); }

  public RealityResponse.Reader getCurrentRealityXR() {
  #if UNITY_2019_1_OR_NEWER
    sbyte[] bytes = androidXR.Call<sbyte[]>("getCurrentRealityXR");
  #else
    byte[] bytes = androidXR.Call<byte[]>("getCurrentRealityXR");
  #endif
    MessageReader r = Serialize.read(bytes);
    return r.getRoot(RealityResponse.factory);
  }

  public XrQueryResponse.Reader query(MessageBuilder request) {
  #if UNITY_2019_1_OR_NEWER
    sbyte[] bytes = androidXR.Call<sbyte[]>("query", Serialize.writeSBytes(request));
  #else
    byte[] bytes = androidXR.Call<byte[]>("query", Serialize.writeBytes(request));
  #endif
    MessageReader r = Serialize.read(bytes);
    return r.getRoot(XrQueryResponse.factory);
  }

  public static XREnvironment.Reader getXREnvironment() {
    // Load the native library required by XRAndroid's JNI layer.
    c8_loadXRDll();

    AndroidJavaClass xrAndroidClass = getXRAndroidClass();
  #if UNITY_2019_1_OR_NEWER
    sbyte[] bytes = xrAndroidClass.CallStatic<sbyte[]>("getXREnvironment", getUnityPlayerAcitivty());
  #else
    byte[] bytes = xrAndroidClass.CallStatic<byte[]>("getXREnvironment", getUnityPlayerAcitivty());
  #endif
    MessageReader r = Serialize.read(bytes);
    return r.getRoot(XREnvironment.factory);
  }

  public XRAppEnvironment.Reader getXRAppEnvironment() {
  #if UNITY_2019_1_OR_NEWER
    sbyte[] bytes = androidXR.Call<sbyte[]>("getXRAppEnvironment");
  #else
    byte[] bytes = androidXR.Call<byte[]>("getXRAppEnvironment");
  #endif
    MessageReader r = Serialize.read(bytes);
    return r.getRoot(XRAppEnvironment.factory);
  }

  public void setXRAppEnvironment(MessageBuilder environment) {
  #if UNITY_2019_1_OR_NEWER
    sbyte[] bytes = Serialize.writeSBytes(environment);
  #else
    byte[] bytes = Serialize.writeBytes(environment);
  #endif
    androidXR.Call("setXRAppEnvironment", bytes);
  }

  public void pause() { androidXR.Call("pause"); }
  public void renderFrameForDisplay() { androidXR.Call("renderFrameForDisplay"); }


#endif
} // class XRAndroidWrapper

} // namespace XRInternal

using System;
using System.Runtime.InteropServices;
using UnityEngine;
/*
public class NativeAPI {
    [DllImport("__Internal")]
    public static extern void unityMessage(string lastStringColor);
}
*/
public class Cube : MonoBehaviour
{

    void Update()
    {
        transform.Rotate(0, Time.deltaTime * 10, 0);
    }

    string lastStringColor = "";
    void ChangeColor(string newColor)
    {
        lastStringColor = newColor;
        Color myColor;
        if (ColorUtility.TryParseHtmlString(newColor, out myColor))
        {
            GetComponent<Renderer>().material.color = myColor;
        } else
        {
            lastStringColor = "#000000";
            GetComponent<Renderer>().material.color = Color.black;
        }
        unityMessage();
    }

    void setColor(Color color)
    {
        lastStringColor = ColorUtility.ToHtmlStringRGB(color);
        GetComponent<Renderer>().material.color = color;
        unityMessage();
    }


    void unityMessage()
    {
#if UNITY_ANDROID
        
        try
        {
            AndroidJavaClass jc = new AndroidJavaClass("com.company.product.OverrideUnityActivity");
            AndroidJavaObject overrideActivity = jc.GetStatic<AndroidJavaObject>("instance");
            overrideActivity.Call("showMainActivity", lastStringColor);
        } catch(Exception e)
        {
            Debug.Log(e);
        }
        
#elif UNITY_IOS
        NativeAPI.unityMessage(lastStringColor);
#endif
    }

    void OnGUI()
    {
        if (GUI.Button(new Rect(10, 10, 200, 100), "Randomize!")) setColor(UnityEngine.Random.ColorHSV(0f, 1f, 1f, 1f, 0.5f, 1f));
    }
}


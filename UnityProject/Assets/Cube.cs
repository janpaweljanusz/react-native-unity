using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine.UI;
using UnityEngine;

public class NativeAPI {
    [DllImport("__Internal")]
    public static extern void randomizeColor(string lastStringColor);
}

public class Cube : MonoBehaviour
{

    void Update()
    {
        transform.Rotate(0, Time.deltaTime*10, 0);
    }

    string lastStringColor = "";
    void ChangeColor(string newColor)
    {

        lastStringColor = newColor;
    
        if (newColor == "red") GetComponent<Renderer>().material.color = Color.red;
        else if (newColor == "blue") GetComponent<Renderer>().material.color = Color.blue;
        else if (newColor == "yellow") GetComponent<Renderer>().material.color = Color.yellow;
        else {
            Color myColor;
            if (ColorUtility.TryParseHtmlString(newColor, out myColor)) {
                setColor(myColor);
            } else GetComponent<Renderer>().material.color = Color.black;
        }
    }

    void setColor(Color color) {
            GetComponent<Renderer>().material.color = color;
    }


    void randomizeColor()
    {
#if UNITY_ANDROID
        try
        {
            AndroidJavaClass jc = new AndroidJavaClass("com.company.product.OverrideUnityActivity");
            AndroidJavaObject overrideActivity = jc.GetStatic<AndroidJavaObject>("instance");
            overrideActivity.Call("showMainActivity", lastStringColor);
        } catch(Exception e)
        {
        }
#elif UNITY_IOS
        NativeAPI.randomizeColor(lastStringColor);
#endif
    }

    void OnGUI()
    {
        if (GUI.Button(new Rect(10, 10, 200, 100), "Randomize!")) setColor(UnityEngine.Random.ColorHSV(0f, 1f, 1f, 1f, 0.5f, 1f));
        randomizeColor();
    }
}


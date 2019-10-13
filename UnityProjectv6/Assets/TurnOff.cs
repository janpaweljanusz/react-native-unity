using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TurnOff : MonoBehaviour
{
    public void TurnMeOff()
    {
        Debug.Log("Quit me");
        Application.Quit();
    }
}
